import psutil   # libreria usata per leggere info su processi e risorse

print("=== REPORT AUTOMATICO PER PC LENTO ===")

# ----- Controllo processi che usano più CPU -----

print("\n-- Processi con ALTA CPU --")

# prendo la lista dei processi e la ordino in base all'uso della CPU
process_by_cpu = sorted(
    psutil.process_iter(['name', 'cpu_percent']),
    key=lambda p: p.info['cpu_percent'],
    reverse=True
)

# mostro solo i primi 5
for proc in process_by_cpu[:5]:
    name = proc.info['name']
    cpu = proc.info['cpu_percent']
    print(f"{name} - CPU: {cpu}%")

# ----- Controllo processi che usano più RAM -----

print("\n-- Processi con ALTA RAM --")

# stessa logica di prima, ma basata sulla RAM
process_by_ram = sorted(
    psutil.process_iter(['name', 'memory_info']),
    key=lambda p: p.info['memory_info'].rss,
    reverse=True
)

# anche qui prendo solo i primi 5
for proc in process_by_ram[:5]:
    name = proc.info['name']
    # converto da byte a MB per avere un valore leggibile
    ram = round(proc.info['memory_info'].rss / (1024 * 1024), 2)
    print(f"{name} - RAM: {ram} MB")

print("\n=== Report completato ===")
