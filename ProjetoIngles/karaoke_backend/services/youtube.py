from pytubefix import YouTube
import os

def download_youtube_audio(url: str, output_path="downloads"):
    os.makedirs(output_path, exist_ok=True)

    yt = YouTube(url)
    audio = yt.streams.filter(only_audio=True).first()

    file_path = audio.download(output_path=output_path, filename="audio.mp4")
    return file_path
