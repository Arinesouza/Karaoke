from services.openai_transcriber import openai_response

async def generate_karaoke(prompt: str):
    """
    Gera uma letra formatada em estilo karaokê usando a API da OpenAI.
    """
    final_prompt = (
        "Formate o texto abaixo como uma letra de karaokê, com quebras de linha, "
        "estrofes separadas e fácil de cantar.\n\n"
        f"TEXTO:\n{prompt}"
    )

    result = await openai_response("gpt-4o-mini", final_prompt)

    return {
        "karaoke_text": result.get("output_text", ""),
        "raw": result
    }
