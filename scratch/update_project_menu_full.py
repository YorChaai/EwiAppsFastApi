import re
from pathlib import Path

path = Path(r"D:\Aplikasi\aitool\project_menu.py")
content = path.read_text(encoding="utf-8")

# 1. Pastikan menu text memiliki 1-21 asli + 22-27
pattern_menu = re.compile(
    r'print\(" \[ DOKUMENTASI & REPOSITORY.*?choice = input\("Pilih menu \(0-\d+\): "\)\.strip\(\)',
    re.DOTALL
)

new_menu_text = '''print(" [ DOKUMENTASI & REPOSITORY ]")
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
            print(" [ FITUR TAMBAHAN DOKUMENTASI & GIT ]")
            print("   24. Generate & Bandingkan Dokumen Standar Saja")
            print("   25. Git: Status & Log Riwayat Commit Terakhir")
            print("   26. Git: Stash / Simpan & Discard Perubahan Lokal")
            print("   27. Git: Kelola Branch (Lihat / Pindah / Buat Branch)")
            print()
            print("   0. Keluar")
            print("=" * 72)

            choice = input("Pilih menu (0-27): ").strip()'''

content = pattern_menu.sub(new_menu_text, content)

# 2. Update handler untuk choice 18 hingga 27
pattern_handlers = re.compile(
    r'elif choice == "18":.*?def run\(project_path=None\):',
    re.DOTALL
)

new_handlers = '''elif choice == "18":
                aitool_doc = Path(__file__).resolve().parent / "docs_generator" / "run_all_docs.py"
                local_doc = self.project_path / "backend" / "scripts" / "run_all_docs.py"
                target_script = str(aitool_doc) if aitool_doc.exists() else str(local_doc)
                
                if Path(target_script).exists():
                    print(f"\\n[INFO] Menjalankan Master Docs Generator untuk: {self.project_path}")
                    subprocess.run([sys.executable, target_script, str(self.project_path)])
                    docs_folder = self.project_path / "docs" / "alldocument"
                    if docs_folder.exists() and input("\\nBuka folder dokumentasi di Explorer? (y/n): ").lower() == "y":
                        open_folder(docs_folder)
                else:
                    print("[!] Script run_all_docs.py tidak ditemukan.")
                    input("Tekan Enter...")

            elif choice == "19":
                branch = self.get_git_branch()
                print(f"\\n[INFO] Menjalankan git pull origin {branch}...")
                subprocess.run(f"git pull origin {branch}", shell=True, cwd=str(self.project_path))
                input("\\nTekan Enter...")

            elif choice == "20":
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

            elif choice == "21":
                try:
                    import app
                    app.main()
                except Exception as e:
                    print(f"[!] Error membuka AI Tools: {e}")
                    input("Tekan Enter...")

            elif choice == "22":
                self.start_backend_if_needed(port=5000)
                self.start_cloudflare_tunnel(port=5000)
                input("\\nTekan Enter untuk kembali ke menu...")

            elif choice == "23":
                self.start_cloudflare_tunnel(port=5000)
                input("\\nTekan Enter untuk kembali ke menu...")

            elif choice == "24":
                aitool_cmp = Path(__file__).resolve().parent / "docs_generator" / "auto_generate_and_compare_docs.py"
                local_cmp = self.project_path / "backend" / "scripts" / "auto_generate_and_compare_docs.py"
                target_cmp = str(aitool_cmp) if aitool_cmp.exists() else str(local_cmp)
                if Path(target_cmp).exists():
                    subprocess.run([sys.executable, target_cmp, str(self.project_path)])
                    banding_folder = self.project_path / "docs" / "alldocument" / "banding"
                    if banding_folder.exists() and input("\\nBuka folder banding di Explorer? (y/n): ").lower() == "y":
                        open_folder(banding_folder)
                else:
                    print("[!] Script auto_generate_and_compare_docs.py tidak ditemukan.")
                    input("Tekan Enter...")

            elif choice == "25":
                branch = self.get_git_branch()
                print("\\n" + "="*56)
                print(f"   GIT STATUS (Branch Aktif: {branch})")
                print("="*56)
                subprocess.run("git status", shell=True, cwd=str(self.project_path))
                print("\\n" + "="*56 + "\\n   5 COMMIT TERAKHIR\\n" + "="*56)
                subprocess.run("git log -n 5 --oneline --graph --decorate", shell=True, cwd=str(self.project_path))
                input("\\nTekan Enter...")

            elif choice == "26":
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

            elif choice == "27":
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

def run(project_path=None):'''

content = pattern_handlers.sub(new_handlers, content)
path.write_text(content, encoding="utf-8")
print("project_menu.py updated with choices 18-27 and clean menu text!")
