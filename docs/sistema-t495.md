# Sistema — ThinkPad T495 (Arch Linux)

Documentazione dell'hardware, delle configurazioni di sistema e degli
interventi di ottimizzazione effettuati sul portatile principale.

> Ultimo aggiornamento: 2026-07-27

## Panoramica hardware

| Componente | Dettaglio |
|---|---|
| **Modello** | Lenovo ThinkPad T495 (`20NJCTO1WW`) |
| **Hostname** | Ph4nt0m |
| **CPU** | AMD Ryzen 7 PRO 3700U — 4 core / 8 thread (Zen+, Picasso) |
| **GPU** | AMD Radeon Vega 10 integrata (driver `radeonsi`, mesa/ACO) |
| **RAM** | 21 GiB |
| **Storage** | NVMe 1 TB (`nvme0n1`, non rotazionale) |
| **Distro** | Arch Linux — kernel `7.0.12-arch1-1` |
| **Init** | systemd |
| **Driver CPU freq** | `acpi-cpufreq` (amd_pstate non usato su Zen+) |

### Layout partizioni

```
nvme0n1 (953,9G)
├─ nvme0n1p1  260M  vfat        /boot
├─ nvme0n1p2   16M  (riservata)
├─ nvme0n1p3  318G  BitLocker   (Windows, non montata)
├─ nvme0n1p4 1000M  ntfs        (Windows recovery)
├─ nvme0n1p5  300G  ext4        /
├─ nvme0n1p6    8G  swap        [SWAP]
└─ nvme0n1p7  327G  ext4        /home
```

Sistema **dual-boot** con Windows (partizioni BitLocker/NTFS non gestite da Linux).

## Ambiente grafico

- **Desktop**: KDE Plasma (Wayland — `kwin_wayland`, `plasmashell`)
- **Display manager**: SDDM
- **Nota**: questa è la macchina Arch/KDE. La configurazione Sway del repo
  (`sway/`, `waybar/`, `mako/`) riguarda l'altra macchina (Artix/OpenRC).

## Power management

Strategia scelta: **TLP** (standard de-facto sui ThinkPad).

- `tlp.service` **enabled + active**.
- `auto-cpufreq` **rimosso** (era in stato `failed`, in conflitto con TLP).
- `power-profiles-daemon` non installato (eviterebbe conflitto con TLP).
- `acpi_call` installato — abilita le funzioni ThinkPad in TLP.

### Soglie di carica batteria

Configurate via drop-in `/etc/tlp.d/10-battery-thresholds.conf`:

```ini
START_CHARGE_THRESH_BAT0=85
STOP_CHARGE_THRESH_BAT0=90
```

Profilo "mobilità": la batteria si mantiene tra **85% e 90%**, evitando la
permanenza costante al 100% (che accelera il degrado delle celle al litio).

### Stato di salute batteria (2026-07-27)

| Metrica | Valore | Note |
|---|---|---|
| Modello cella | LGC `5B10W139` | Ricambio: `5B10W13906` |
| Capacità di progetto | 50.500 mWh | Da nuova |
| Capacità attuale | 30.250 mWh | Reale oggi |
| **Salute (SoH)** | **~60%** | Perso ~40% |
| **Cicli di carica** | **3.240** | Molto elevato (fine vita) |

**Valutazione**: batteria a fine vita utile ma dignitosa per 3.240 cicli.
Le soglie 85/90 rallentano il degrado da qui in avanti. Se serve autonomia,
valutare sostituzione (`5B10W13906`, ~45Wh, batteria interna sostituibile).
Ricontrollare `energy_full` e `cycle_count` tra qualche mese per monitorare
l'accelerazione del degrado (`sudo tlp-stat -b`).

## Ottimizzazioni applicate (2026-07-27)

| # | Intervento | Comando / File | Stato |
|---|---|---|---|
| 1 | Pulizia cache pacman (18G → 8.3G) | `paccache -rk2` + `paccache -ruk0` | ✅ |
| 2 | TRIM periodico SSD | `systemctl enable --now fstrim.timer` | ✅ |
| 3 | Limite dimensione journal | `/etc/systemd/journald.conf.d/size-limit.conf` | ✅ |
| 4a | Disabilitato wait-online al boot | `systemctl disable NetworkManager-wait-online` | ✅ |
| 4b | Docker on-demand (socket activation) | `disable docker.service` + `enable docker.socket` | ✅ |
| 5 | Power management via TLP | `enable --now tlp.service` (rimosso auto-cpufreq) | ✅ |
| 6 | `vm.swappiness` 60 → 10 | `/etc/sysctl.d/99-swappiness.conf` | ✅ |

### Dettaglio configurazioni di sistema

**Journal systemd** — `/etc/systemd/journald.conf.d/size-limit.conf`:
```ini
[Journal]
SystemMaxUse=500M
MaxRetentionSec=4week
```

**Docker** — avvio on-demand: `docker.service` disabilitato, `docker.socket`
enabled. Il demone parte al primo comando `docker`. ⚠️ I container con
`restart: always` non ripartono al boot finché non si interagisce con Docker.

**Swappiness** — `/etc/sysctl.d/99-swappiness.conf`:
```ini
vm.swappiness=10
```
Con 21 GiB di RAM riduce l'uso prematuro dello swap su disco (default 60).

## Manutenzione periodica consigliata

- **Cache pacman**: `sudo paccache -rk2` ogni tanto (o timer `paccache`).
- **Pacchetti orfani**: `pacman -Qdtq | sudo pacman -Rns -` (controllare la
  lista prima — alcuni runtime Qt5/lua potrebbero servire ad app non-pacman).
- **Aggiornamento sistema**: `sudo pacman -Syu` (Arch è rolling release).
- **Salute batteria**: `sudo tlp-stat -b` ogni qualche mese.
- **TRIM**: automatico settimanale via `fstrim.timer` (nessuna azione).

## TODO / valutazioni aperte

- [ ] Valutare **zram** (swap compresso in RAM) al posto/affianco della
      partizione swap da 8G su disco.
- [ ] Ripulire eventuali **reti Docker** inutilizzate (`docker network prune`):
      sono presenti ~10 bridge `br-*` da progetti compose.
- [ ] `baloo_file` (indexer KDE) usa ~1.3 GiB — disattivabile se non si usa
      la ricerca file di Plasma (`balooctl disable`).
- [ ] Valutare se **versionare nel repo** i drop-in di sistema
      (`journald.conf.d`, `tlp.d`) per replicarli tra le macchine.
