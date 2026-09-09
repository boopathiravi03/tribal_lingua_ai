import torch

from transformers import (
    AutoModelForSeq2SeqLM,
    AutoTokenizer,
)

from IndicTransToolkit import IndicProcessor


MODEL_NAME = (
    "ai4bharat/indictrans2-indic-indic-dist-320M"
)

SRC_LANG = "hin_Deva"
TGT_LANG = "sat_Olck"


class IndicTransService:

    def __init__(self):

        print("Loading IndicTrans2...")

        self.device = (
            "cuda"
            if torch.cuda.is_available()
            else "cpu"
        )

        print(f"Device: {self.device}")

        self.tokenizer = (
            AutoTokenizer.from_pretrained(
                MODEL_NAME,
                trust_remote_code=True,
            )
        )

        self.model = (
            AutoModelForSeq2SeqLM.from_pretrained(
                MODEL_NAME,
                trust_remote_code=True,
            )
        )

        self.model.to(self.device)

        self.model.eval()

        self.processor = IndicProcessor(
            inference=True
        )

        print(
            "IndicTrans2 loaded successfully."
        )


    def translate(
        self,
        text: str,
    ) -> str:

        if not text.strip():
            return ""

        sentences = [text]

        batch = (
            self.processor.preprocess_batch(
                sentences,
                src_lang=SRC_LANG,
                tgt_lang=TGT_LANG,
            )
        )

        inputs = self.tokenizer(
            batch,
            return_tensors="pt",
            padding=True,
            truncation=True,
            max_length=256,
        )

        inputs = {
            key: value.to(self.device)
            for key, value in inputs.items()
        }

        with torch.no_grad():

            generated_tokens = (
                self.model.generate(
                    **inputs,
                    use_cache=True,
                    min_length=0,
                    max_length=256,
                    num_beams=5,
                    num_return_sequences=1,
                )
            )

        generated_tokens = (
            self.tokenizer.batch_decode(
                generated_tokens,
                skip_special_tokens=True,
                clean_up_tokenization_spaces=True,
            )
        )

        translations = (
            self.processor.postprocess_batch(
                generated_tokens,
                lang=TGT_LANG,
            )
        )

        return translations[0]


    def translate_many(
        self,
        texts: list[str],
    ) -> list[str]:

        results = []

        for text in texts:

            if not text or not text.strip():
                results.append("")
                continue

            results.append(
                self.translate(text)
            )

        return results
