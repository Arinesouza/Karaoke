from dotenv import load_dotenv 

load_dotenv()
import os
import openai

OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

if not OPENAI_API_KEY:
    raise ValueError("Você precisa definir a variável OPENAI_API_KEY no .env !")


client = openai.OpenAI() 

# NOTA: O modelo "gpt-4o-audio-preview" não existe. O modelo correto para transcrição é "whisper-1".

async def transcribe_audio(file):
    """
    Usa a biblioteca oficial da OpenAI (Whisper) para transcrever áudio.
    """
    
    try:
       
        transcript = client.audio.transcriptions.create(
            model="whisper-1", 
            file=file.file,    
            language="en"      
        )
        
        # O resultado da transcrição do 'whisper-1' vem no formato { 'text': '...' }
        return {"transcribed_text": transcript.text, "text": transcript.text} 

    except openai.APIStatusError as e:
        print(f"Erro da OpenAI: {e.status_code} - {e.response.json()}")
        raise Exception(f"Erro da OpenAI: {e.status_code} - {e.response.json().get('error', {}).get('message', 'Erro desconhecido')}")
    except Exception as e:
        raise Exception(f"Erro ao transcrever: {str(e)}")


async def openai_response(model: str, prompt: str):
    """
    Usa o cliente OpenAI para gerar a letra estilizada (Karaokê).
    Esta função deve ser usada dentro do generate_karaoke.
    """
    try:
        response = client.chat.completions.create(
            model=model, 
            messages=[
                {"role": "system", "content": "Você é um gerador de letras de karaokê. Estilize a letra fornecida."},
                {"role": "user", "content": prompt}
            ]
        )
        return {"response_text": response.choices[0].message.content}
    except openai.APIStatusError as e:
        print(f"Erro da OpenAI: {e.status_code} - {e.response.json()}")
        raise Exception(f"Erro da OpenAI: {e.status_code} - {e.response.json().get('error', {}).get('message', 'Erro desconhecido')}")
    except Exception as e:
        raise Exception(f"Erro ao gerar resposta: {str(e)}")

