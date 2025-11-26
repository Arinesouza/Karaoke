import os
import torch
import librosa
from transformers import pipeline

device = "cuda:0" if torch.cuda.is_available() else "cpu"
transcriber = pipeline("automatic-speech-recognition", model="openai/whisper-small", device=device)

async def transcribe_audio_hf(file):
    """
    Transcreve áudio usando o modelo Whisper local (Hugging Face).
    A função recebe o objeto UploadFile do FastAPI.
    """
    temp_path = None
    try:
        
        temp_path = f"temp_upload_{file.filename}"
        
        
        file.file.seek(0)
        
        with open(temp_path, "wb") as buffer:
            for chunk in file.file:
                buffer.write(chunk)

       
        audio_data, sr = librosa.load(temp_path, sr=16000)
        
       
        transcription_result = transcriber(audio_data)

        transcribed_text = transcription_result["text"]
        
        return {"transcribed_text": transcribed_text, "text": transcribed_text}

    except Exception as e:
        print(f"Erro na transcrição local (Whisper HF): {str(e)}")
        raise Exception(f"Erro na transcrição local (Whisper HF): {str(e)}")
        
    finally:
        if temp_path and os.path.exists(temp_path):
            os.remove(temp_path)