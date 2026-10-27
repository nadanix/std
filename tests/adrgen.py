# SPDX-FileCopyrightText: The Standard Authors
# SPDX-License-Identifier: Unlicense

"""Run only in a disposable workspace; see src/tests/adrgen.nix."""

from datetime import date
from html.parser import HTMLParser
from pathlib import Path
import re
import shutil
import subprocess


class TemplatePage(HTMLParser):
    def __init__(self, text):
        super().__init__()
        self.in_main = False
        self.in_heading = False
        self.in_code = False
        self.headings = []
        self.code = []
        self.feed(text)

    def handle_starttag(self, tag, attrs):
        if tag == "main":
            self.in_main = True
        elif tag == "h1" and self.in_main:
            self.in_heading = True
        elif tag == "code" and self.in_main:
            self.in_code = True

    def handle_endtag(self, tag):
        if tag == "main":
            self.in_main = False
        elif tag == "h1":
            self.in_heading = False
        elif tag == "code":
            self.in_code = False

    def handle_data(self, data):
        if self.in_heading:
            self.headings.append(data)
        if self.in_code:
            self.code.append(data)


def main():
    directory = Path("docs/explain/architecture-decision-records")
    existing = {p.name: p.read_bytes() for p in directory.iterdir() if p.is_file()}
    ids = [int(m[1]) for name in existing if (m := re.fullmatch(r"(\d+)-.+\.md", name))]
    next_id = max(ids, default=0) + 1
    title = "ADR generation smoke test"
    filename = f"{next_id:04d}-adr-generation-smoke-test.md"

    # adrgen can report errors with exit zero: verify the output, not just status.
    subprocess.run(["adrgen", "create", title], check=True)
    generated = directory / filename
    assert generated.is_file(), f"Expected ADR was not created: {generated}"
    content = generated.read_text()
    match = re.search(r"^Date: (\d{4}-\d{2}-\d{2})$", content, re.M)
    assert match, "Date placeholder was not replaced"
    date.fromisoformat(match[1])
    template = (directory / "template.md.in").read_text()
    expected = (
        template.replace("{title}", f"{next_id}. {title}")
        .replace("{date}", match[1])
        .replace("{status}", "proposed")
    )
    assert content == expected, "Generated ADR differs from the source template"
    assert content.splitlines()[0] == f"# {next_id}. {title}"
    listing = subprocess.check_output(["adrgen", "list"], text=True)
    assert title in listing and filename in listing
    assert {p.name for p in directory.iterdir()} == set(existing) | {filename}
    assert all((directory / name).read_bytes() == data for name, data in existing.items())
    assert not Path("docs/explain/any-decision-records").exists()

    # Check the book-facing page separately, with the actual mdBook include parser.
    book = Path("template-book")
    source = book / "src"
    source.mkdir(parents=True)
    for name in ["template.md", "template.md.in"]:
        shutil.copyfile(directory / name, source / name)
    (book / "book.toml").write_text('[book]\ntitle = "ADR template test"\nsrc = "src"\n')
    (source / "SUMMARY.md").write_text("# Summary\n\n- [ADR template](template.md)\n")
    subprocess.run(["mdbook", "build", str(book)], check=True)
    page = TemplatePage((book / "book/template.html").read_text())
    assert "".join(page.headings).strip() == "ADR template", "Missing visible template heading"
    assert template in "".join(page.code), "Book must display the complete raw template"
    print("PASS: ADR generation/listing, existing records preserved, template heading and source rendered")


if __name__ == "__main__":
    main()
