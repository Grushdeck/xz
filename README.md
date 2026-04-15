# MiniOS 16-bit - NASM Operating System

## Сборка
```
nasm -f bin boot.asm -o boot.bin
nasm -f bin kernel.asm -o kernel.bin
copy /b boot.bin+kernel.bin os.img
```

## Запуск
```
qemu-system-i386 -fda os.img -soundhw pcspk
```

## Управление
- Мышь: двигать курсор, левая кнопка - клик
- F1 - запуск демо-программы (графика)
- F2 - запуск музыкального плеера (PC Speaker)
- F3 - рисовалка мышью
- ESC - возврат в рабочий стол
---

# p.s: тестовый репозиторий
