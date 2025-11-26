from rapidfuzz.distance import Levenshtein
import re

def normalize(text):
    text = text.lower()
    text = re.sub(r"[^a-z0-9\s]", "", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()

def calculate_score(original: str, spoken: str):
    original_n = normalize(original)
    spoken_n = normalize(spoken)

    distance = Levenshtein.distance(original_n, spoken_n)
    max_len = max(len(original_n), 1)

    score = max(0, 1 - distance / max_len) * 100
    return round(score, 2)
