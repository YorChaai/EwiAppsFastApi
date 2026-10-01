import sys
import re
from pathlib import Path

def update_menu():
    path = Path(r"D:\Aplikasi\aitool\project_menu.py")
    content = path.read_text(encoding="utf-8")

    # 1. Tambahkan helper get_git_branch jika belum ada
    if "def get_git_branch" not in content:
        helper_code = '''
    def get_git_branch(self):
        try:
            res = subprocess.run(
                "git rev-parse --abbrev-ref HEAD",
                shell=True,
                cwd=str(self.project_path),
                capture_output=True,
                text=True
            )
            if res.returncode == 0 and res.stdout.strip():
                return res.stdout.strip()
        except Exception:
            pass
        return "main"
'''
        target = "def __init__(self, project_path):"
        idx = content.find(target)
        if idx != -1:
            content = content[:idx] + helper_code.strip() + "\n\n    " + content[idx:]
            print("Helper get_git_branch inserted.")

    # 2. Update teks menu tampilan
    old_menu_section = '''            print(" [ DOKUMENTASI & REPOSITORY ]")
            print("   18. Generate Dokumentasi Sistem Lengkap")
            print("   19. Git Pull (Tarik Update Terbaru dari Repository)")
            print("   20. Git Push dan Commit (Kirim Perubahan ke Repository)")
            print()
            print(" [ AI TOOLS & ASISTEN ]")
            print("   21. Buka AI Tools Control Center (Graphify, Ponytail, 9Router, Playwright)")
            print()
            print(" [ REMOTE & AKSES HP (CLOUDFLARE TUNNEL) ]")
            print("   22. Full Stack: Akses HP / Klien (Backend + Cloudflare Tunnel)")
            print("   23. Jalankan Cloudflare Tunnel Saja (Port 5000 -> Link Publik)")
            print()
            print("   0. Keluar")
            print("=" * 72)

            choice = input("Pilih menu (0-23): ").strip()'''

    new_menu_section = '''            print(" [ DOKUMENTASI & REPOSITORY / GIT ]")
            print("   18. Generate Dokumentasi Sistem Lengkap")
            print("   19. Git: Status & Log Riwayat Commit")
            print("   20. Git: Pull (Tarik Update dari Remote Branch Aktif)")
            print("   21. Git: Commit & Push (Add Semua, Beri Pesan & Push)")
            print("   22. Git: Stash / Simpan & Discard Perubahan Lokal")
            print("   23. Git: Kelola Branch (Lihat / Pindah / Buat Branch)")
            print()
            print(" [ REMOTE & AKSES HP (CLOUDFLARE TUNNEL) ]")
            print("   24. Full Stack: Akses HP / Klien (Backend + Cloudflare Tunnel)")
            print("   25. Jalankan Cloudflare Tunnel Saja (Port 5000 -> Link Publik)")
            print()
            print(" [ AI TOOLS & ASISTEN ]")
            print("   26. Buka AI Tools Control Center (Graphify, Ponytail, 9Router, Playwright)")
            print()
            print("   0. Keluar")
            print("=" * 72)

            choice = input("Pilih menu (0-26): ").strip()'''

    if old_menu_section in content:
        content = content.replace(old_menu_section, new_menu_section)
        print("Menu text updated (0-26).")
    else:
        print("Warning: old_menu_section not found directly, looking for regex or alternative...")

    # 3. Update handler choice 19 sampai 26
    old_handlers_pattern = re.compile(
        r'elif choice == "19":.*?elif choice == "23":\s+self\.start_cloudflare_tunnel\(port=5000\)\s+input\("\\nTekan Enter untuk kembali ke menu\.\.\."\)',
        re.DOTALL
    )

    new_handlers = '''elif choice == "19":
                branch = self.get_git_branch()
                print(f"\\n========================================================")
                print(f"   GIT STATUS (Branch Aktif: {branch})")
                print(f"========================================================")
                subprocess.run("git status", shell=True, cwd=str(self.project_path))
                print(f"\\n========================================================")
                print("   5 COMMIT TERAKHIR")
                print("========================================================")
                subprocess.run("git log -n 5 --oneline --graph --decorate", shell=True, cwd=str(self.project_path))
                input("\\nTekan Enter...")

            elif choice == "20":
                branch = self.get_git_branch()
                print(f"\\n[INFO] Menjalankan git pull origin {branch}...")
                subprocess.run(f"git pull origin {branch}", shell=True, cwd=str(self.project_path))
                input("\\nTekan Enter...")

            elif choice == "21":
                branch = self.get_git_branch()
                print(f"\\n[INFO] Branch Aktif: {branch}")
                print("\\n[Status Perubahan:]")
                subprocess.run("git status --short", shell=True, cwd=str(self.project_path))
                msg = input("\\nMasukkan pesan commit (kosongkan untuk batal): ").strip()
                if msg:
                    print("\\n[1/3] Menjalankan git add . ...")
                    subprocess.run("git add .", shell=True, cwd=str(self.project_path))
                    print("[2/3] Menjalankan git commit...")
                    subprocess.run(f'git commit -m "{msg}"', shell=True, cwd=str(self.project_path))
                    print(f"[3/3] Menjalankan git push origin {branch}...")
                    push_res = subprocess.run(f"git push origin {branch}", shell=True, cwd=str(self.project_path))
                    if push_res.returncode != 0:
                        print(f"\\n[!] Push normal gagal. Mencoba 'git push -u origin {branch}'...")
                        subprocess.run(f"git push -u origin {branch}", shell=True, cwd=str(self.project_path))
                    print("\\n[v] Commit & Push selesai!")
                else:
                    print("[i] Commit dibatalkan.")
                input("\\nTekan Enter...")

            elif choice == "22":
                print("\\n=== GIT STASH / KELOLA PERUBAHAN ===")
                print("1. Stash (Simpan perubahan lokal sementara)")
                print("2. Stash Pop (Kembalikan perubahan dari stash)")
                print("3. Stash List (Lihat riwayat stash)")
                print("4. Discard Semua Perubahan Lokal (git restore . + clean)")
                print("0. Batal")
                sub = input("Pilih (0-4): ").strip()
                if sub == "1":
                    smsg = input("Label stash (opsional): ").strip()
                    cmd = f'git stash save "{smsg}"' if smsg else "git stash"
                    subprocess.run(cmd, shell=True, cwd=str(self.project_path))
                elif sub == "2":
                    subprocess.run("git stash pop", shell=True, cwd=str(self.project_path))
                elif sub == "3":
                    subprocess.run("git stash list", shell=True, cwd=str(self.project_path))
                elif sub == "4":
                    conf = input("Yakin ingin MENGHAPUS SEMUA perubahan lokal belum commit? (y/n): ")
                    if conf.lower() == "y":
                        subprocess.run("git restore .", shell=True, cwd=str(self.project_path))
                        subprocess.run("git clean -fd", shell=True, cwd=str(self.project_path))
                        print("[v] Perubahan lokal telah dibersihkan.")
                input("\\nTekan Enter...")

            elif choice == "23":
                print("\\n=== DAFTAR BRANCH ===")
                subprocess.run("git branch -a", shell=True, cwd=str(self.project_path))
                target_branch = input("\\nKetik nama branch untuk beralih/buat baru (Enter untuk batal): ").strip()
                if target_branch:
                    res = subprocess.run(f"git checkout {target_branch}", shell=True, cwd=str(self.project_path))
                    if res.returncode != 0:
                        create = input(f"Branch '{target_branch}' belum ada. Buat branch baru? (y/n): ")
                        if create.lower() == "y":
                            subprocess.run(f"git checkout -b {target_branch}", shell=True, cwd=str(self.project_path))
                input("\\nTekan Enter...")

            elif choice == "24":
                self.start_backend_if_needed(port=5000)
                self.start_cloudflare_tunnel(port=5000)
                input("\\nTekan Enter untuk kembali ke menu...")

            elif choice == "25":
                self.start_cloudflare_tunnel(port=5000)
                input("\\nTekan Enter untuk kembali ke menu...")

            elif choice == "26":
                try:
                    import app
                    app.main()
                except Exception as e:
                    print(f"[!] Error membuka AI Tools: {e}")
                    input("Tekan Enter...")'''

    if old_handlers_pattern.search(content):
        content = old_handlers_pattern.sub(new_handlers, content)
        print("Handlers for 19-26 updated successfully via regex.")
    else:
        print("Warning: old_handlers_pattern did not match!")

    path.write_text(content, encoding="utf-8")
    print("project_menu.py written successfully.")

if __name__ == "__main__":
    update_menu()
