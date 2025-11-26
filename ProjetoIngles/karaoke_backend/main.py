from dotenv import load_dotenv

load_dotenv() 

from fastapi import FastAPI, File, UploadFile, HTTPException, Form 
from fastapi.middleware.cors import CORSMiddleware
from services.hf_transcriber import transcribe_audio, openai_response
from services.youtube import download_youtube_audio
from services.karaoke_generator import generate_karaoke
from services.aligner import align_text_and_audio
from fastapi.datastructures import UploadFile as FastUploadFile
import os 

app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
def home():
    return {"status": "ok", "message": "Karaoke Backend Ativo!"}



@app.post("/transcribe")
async def transcribe_endpoint(file: UploadFile = File(...)):
    try:
        # Chama o serviço de transcrição (por exemplo, Whisper da OpenAI)
        result = await transcribe_audio(file)
        return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))



@app.post("/transcribe/youtube")
async def transcribe_youtube(url: str):
    try:
        audio_path = download_youtube_audio(url)

        with open(audio_path, "rb") as audio_file:
            file = FastUploadFile(
                filename="youtube_audio.mp3",
                file=audio_file,
            )
            result = await transcribe_audio(file)
        
        os.remove(audio_path)
        
        return result

    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@app.post("/generate_karaoke")
async def karaoke_endpoint(url: str = Form(...)): 
    try:
        # 1. Baixa o áudio do YouTube
        audio_path = download_youtube_audio(url)

        # 2. Reabre o arquivo, transcreve, e garante o fechamento
        with open(audio_path, "rb") as audio_file:
            file = FastUploadFile(
                filename="youtube_audio.mp3",
                file=audio_file,
            )

            # 3. Transcreve o áudio 
            transcription_result = await transcribe_audio(file)
            
        # 4. Usa o texto transcrito para gerar a letra estilizada
        transcribed_text = transcription_result.get("text", "") 
        
        # 5. Chama o serviço de geração de Karaokê (LLM)
        result = await generate_karaoke(transcribed_text)
        
        os.remove(audio_path)
        
        return result

    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Erro no processamento do Karaoke: {str(e)}")



@app.post("/align")
async def align_endpoint(
    text: str,
    file: UploadFile = File(...)
):
    try:
        result = align_text_and_audio(text, file)
        return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))