from pathlib import Path

DOCS_DIR = Path("./Documentation")
PROMPTS_DIR = Path("./Prompts")

PROMPTS_DIR.mkdir(exist_ok=True)

generated = 0
failed = 0

print()
print("=" * 50)
print("Hermes Prompt Extraction")
print("=" * 50)
print()

for md_file in sorted(DOCS_DIR.glob("*.md")):

    try:

        text = md_file.read_text(encoding="utf-8")

        lines = text.splitlines()

        in_prompt_section = False
        in_code_block = False

        prompt_lines = []

        for line in lines:

            if line.strip().lower() == "## system prompt":
                in_prompt_section = True
                continue

            if not in_prompt_section:
                continue

            if line.strip().startswith("```") and not in_code_block:
                in_code_block = True
                continue

            if line.strip().startswith("```") and in_code_block:
                break

            if in_code_block:
                prompt_lines.append(line)

        if not prompt_lines:
            print(f"[WARN] No prompt found in {md_file.name}")
            failed += 1
            continue

        prompt_text = "\n".join(prompt_lines).strip()

        output_file = PROMPTS_DIR / f"{md_file.stem}.prompt"

        output_file.write_text(
            prompt_text + "\n",
            encoding="utf-8"
        )

        print(f"[OK] {output_file.name}")

        generated += 1

    except Exception as e:
        print(f"[ERROR] {md_file.name}: {e}")
        failed += 1

print()
print("=" * 50)
print("Summary")
print("=" * 50)
print()

print(f"Generated : {generated}")
print(f"Failed    : {failed}")
print()