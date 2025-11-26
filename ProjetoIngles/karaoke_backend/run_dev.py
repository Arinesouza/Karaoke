import os
import socket
import subprocess

# 1. Encontra o IP da máquina
def get_local_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # Tenta conectar a um endereço externo inofensivo para descobrir o IP local
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        s.close()
    return IP

# 2. Gera o conteúdo Dart
def generate_dart_config(ip):
    dart_content = f"""// ESTE ARQUIVO FOI GERADO AUTOMATICAMENTE PELO SCRIPT!
// NÃO EDITE MANUALMENTE.
class ApiConfig {{
  static const String BASE_URL = 'http://{ip}:8000';
}}
"""
    return dart_content

# 3. Execução
if __name__ == "__main__":
    local_ip = get_local_ip()
    
    # Path para o arquivo Dart no projeto Flutter
    config_path = os.path.join("..", "karaoke_whisper", "lib", "config", "api_config.dart") # <- AJUSTE O PATH CONFORME SEU PROJETO
    
    print(f"IP Local Detectado: {local_ip}")
    
    # Escreve o arquivo Dart
    try:
        with open(config_path, "w") as f:
            f.write(generate_dart_config(local_ip))
        print(f"Arquivo '{config_path}' atualizado com sucesso!")
    except FileNotFoundError:
        print(f"ERRO: Não encontrei o arquivo em {config_path}. Verifique o caminho.")
        exit(1)

    # Inicia o Uvicorn
    print("\nIniciando Uvicorn...")
    try:
        # Comando para iniciar o uvicorn 
        subprocess.run(["uvicorn", "main:app", "--reload", "--host", "0.0.0.0", "--port", "8000"])
    except FileNotFoundError:
        print("ERRO: Uvicorn não encontrado. Verifique se o VENV está ativado.")