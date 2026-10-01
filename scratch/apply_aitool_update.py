import sys
import os
from pathlib import Path

def update_capture_tunnel():
    path = Path(r"D:\Aplikasi\aitool\tools\cloudflare\capture_tunnel.py")
    if not path.exists():
        print(f"File not found: {path}")
        return
    content = path.read_text(encoding="utf-8")
    old_line = 'cmd = [exe_path, "tunnel", "--url", "http://localhost:5000"]'
    new_line = '''port = sys.argv[1] if len(sys.argv) > 1 else "5000"\n    cmd = [exe_path, "tunnel", "--url", f"http://localhost:{port}"]'''
    if old_line in content:
        content = content.replace(old_line, new_line)
        path.write_text(content, encoding="utf-8")
        print("capture_tunnel.py updated successfully.")
    else:
        print("old_line not found in capture_tunnel.py (might already be updated)")

def update_project_menu():
    path = Path(r"D:\Aplikasi\aitool\project_menu.py")
    if not path.exists():
        print(f"File not found: {path}")
        return
    content = path.read_text(encoding="utf-8")

    # 1. Tambahkan method start_cloudflare_tunnel setelah start_backend_if_needed
    method_code = '''
    def start_cloudflare_tunnel(self, port=5000):
        aitool_cf = Path(__file__).parent / "tools" / "cloudflare"
        proj_cf = self.project_path / "side" / "tools" / "cloudflare"
        proj_cf2 = self.project_path / "tools" / "cloudflare"

        cf_dir = None
        if (aitool_cf / "cloudflared.exe").exists():
            cf_dir = aitool_cf
        elif (proj_cf / "cloudflared.exe").exists():
            cf_dir = proj_cf
        elif (proj_cf2 / "cloudflared.exe").exists():
            cf_dir = proj_cf2

        if not cf_dir and not shutil.which("cloudflared"):
            print("[!] cloudflared.exe tidak ditemukan di aitool ataupun di proyek!")
            input("Tekan Enter...")
            return

        print(f"\\n[INFO] Menjalankan Cloudflare Tunnel untuk Port {port}...")
        if cf_dir and (cf_dir / "capture_tunnel.py").exists():
            py_exe = "python"
            if self.backend_dir and (self.backend_dir / "venv" / "Scripts" / "python.exe").exists():
                py_exe = str(self.backend_dir / "venv" / "Scripts" / "python.exe")
            cmd = f'start "Cloudflare Tunnel ({self.name})" cmd /k "cd /d "{cf_dir}" && "{py_exe}" capture_tunnel.py {port}"'
        else:
            exe = str(cf_dir / "cloudflared.exe") if cf_dir else "cloudflared"
            cmd = f'start "Cloudflare Tunnel ({self.name})" cmd /k ""{exe}" tunnel --url http://localhost:{port}"'

        subprocess.Popen(cmd, shell=True)
        print("[v] Jendela Cloudflare Tunnel telah dibuka!")
        print("[i] Tunggu hingga muncul link https://....trycloudflare.com di jendela tersebut.")
        print("[i] Salin link tersebut dan masukkan ke HP / bagikan ke klien.")
'''

    if "def start_cloudflare_tunnel" not in content:
        target_after = "time.sleep(3)"
        idx = content.find(target_after)
        if idx != -1:
            idx += len(target_after)
            content = content[:idx] + method_code + content[idx:]
            print("Method start_cloudflare_tunnel inserted.")
        else:
            print("Could not find insertion point for start_cloudflare_tunnel!")

    # 2. Tambahkan tampilan menu
    old_menu_text = '''            print(" [ AI TOOLS & ASISTEN ]")
            print("   21. Buka AI Tools Control Center (Graphify, Ponytail, 9Router, Playwright)")
            print()
            print("   0. Keluar")
            print("=" * 72)

            choice = input("Pilih menu (0-21): ").strip()'''

    new_menu_text = '''            print(" [ AI TOOLS & ASISTEN ]")
            print("   21. Buka AI Tools Control Center (Graphify, Ponytail, 9Router, Playwright)")
            print()
            print(" [ REMOTE & AKSES HP (CLOUDFLARE TUNNEL) ]")
            print("   22. Full Stack: Akses HP / Klien (Backend + Cloudflare Tunnel)")
            print("   23. Jalankan Cloudflare Tunnel Saja (Port 5000 -> Link Publik)")
            print()
            print("   0. Keluar")
            print("=" * 72)

            choice = input("Pilih menu (0-23): ").strip()'''

    if old_menu_text in content:
        content = content.replace(old_menu_text, new_menu_text)
        print("Menu text updated (0-23).")
    else:
        print("old_menu_text not found in project_menu.py")

    # 3. Tambahkan handler choice 22 & 23
    handler_code = '''            elif choice == "22":
                self.start_backend_if_needed(port=5000)
                self.start_cloudflare_tunnel(port=5000)
                input("\\nTekan Enter untuk kembali ke menu...")

            elif choice == "23":
                self.start_cloudflare_tunnel(port=5000)
                input("\\nTekan Enter untuk kembali ke menu...")
'''

    old_choice_21 = '''            elif choice == "21":
                try:
                    import app
                    app.main()
                except Exception as e:
                    print(f"[!] Error membuka AI Tools: {e}")
                    input("Tekan Enter...")'''

    new_choice_21 = old_choice_21 + "\n" + handler_code

    if old_choice_21 in content and "elif choice == \"22\":" not in content:
        content = content.replace(old_choice_21, new_choice_21)
        print("Handlers for choice 22 & 23 added.")
    else:
        print("choice 21 block not matched or choice 22 already exists.")

    path.write_text(content, encoding="utf-8")
    print("D:\\Aplikasi\\aitool\\project_menu.py written successfully!")

if __name__ == "__main__":
    update_capture_tunnel()
    update_project_menu()
