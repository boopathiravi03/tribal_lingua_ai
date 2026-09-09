import torch
from transformers import AutoModelForSeq2SeqLM, AutoTokenizer
from IndicTransToolkit import IndicProcessor

MODEL_NAME = "ai4bharat/indictrans2-indic-en-1B"

print("Loading tokenizer...")

tokenizer = AutoTokenizer.from_pretrained(
    MODEL_NAME,
    trust_remote_code=True
)

print("Loading model...")

model = AutoModelForSeq2SeqLM.from_pretrained(
    MODEL_NAME,
    trust_remote_code=True
)

processor = IndicProcessor(inference=True)

source_text = "இது ஒரு சோதனை வாக்கியம்."

src_lang = "tam_Taml"
tgt_lang = "eng_Latn"

batch = processor.preprocess_batch(
    [source_text],
    src_lang=src_lang,
    tgt_lang=tgt_lang
)

inputs = tokenizer(
    batch,
    truncation=True,
    padding="longest",
    return_tensors="pt"
)

with torch.no_grad():
    generated_tokens = model.generate(
        **inputs,
        max_length=256,
        num_beams=5
    )

decoded = tokenizer.batch_decode(
    generated_tokens,
    skip_special_tokens=True
)

translations = processor.postprocess_batch(
    decoded,
    lang=tgt_lang
)

print("\nSOURCE:")
print(source_text)

print("\nTRANSLATION:")
print(translations[0])
