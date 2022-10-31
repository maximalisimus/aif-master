# aif-master

---

aif-master - Bash скрипт для установки системы Archlinux на компьютер.

aif-master - Bash script for installing the Archlinux system on a computer.

![Application](./image/aif-image.png "aif-master")

<a name="Oglavlenie"></a>

## Оглавление

1. [Информация](#Информация)
2. [Information](#Information)
4. [Использование](#Использование)
5. [Uses](#Uses)
6. [Обо Мне](#aboutrus)
7. [About](#abouten)


## <a name="Информация">Информация</a>

Данный скрипт предназначен для установки системы **Archlinux** в псевдографическом режиме, 
с помощью утилиты **dialog**.

Скрипт можно использовать с абсолютно любым дистрибутивом *Archlunux*, кроме **bootstrap** и **arm** версии. 

Данный мастер поддерживает **UEFI** режим установки при запуске системы *ArchLinux* в режиме *UEFI*.

Данному установщику **не нужен** ни **XORG**, ни рабочее окружение ( **Desktop environment** ), ни дисплейный менеджер 
( **Display Manager** ). Данный скрипт работает полностью в консольном режиме. Достаточно только 
наличия подключения к интернету и 2 пакетов **dialog** и **ncurses**.

Вы можете использовать данный мастер установки для самых разных режимов использования системы ArchLinux.

Например, не устанавливать графическую часть (XORG, Desktop Environment, Display Manager, драйвер видеокарты и другие), 
чтобы использовать в качестве сервера.

Или выбрать и установить только необходимые пакеты и использовать в качестве Настольного ПК.
Независимо от местоположения вашего компьютера - будь то офис или домашний ПК.

---

[К оглавлению](#Oglavlenie)

## <a name="Information">Information</a>

This script is intended for installing the **Archlinux** system in pseudographic mode, 
using the **dialog** utility.

The script can be used with absolutely any *Archlinux* distribution, except for 
**bootstrap** and **arm** versions.

This wizard supports **UEFI** installation mode when starting the *ArchLinux* system in *UEFI* mode.

This installer **does not need** either **XORG**, nor a working environment 
( **Desktop environment** ), nor a display manager ( **Display Manager** ). 
This script works completely in console mode. It is enough only
to have an Internet connection and 2 packages **dialog** and **ncurses**.

You can use this installation wizard for a variety of modes of using the ArchLinux system.

For example, do not install the graphics part (XORG, Desktop Environment, Display Manager, graphics card driver, and others)
to use as a server.

Or choose and install only the necessary packages and use as a Desktop PC.
Regardless of the location of your computer - whether it's an office or a home PC.

---

[К оглавлению](#Oglavlenie)

## <a name="Использование">Использование</a>

### Базовая информация

Для использования данного мастера необходимо соблюдать 2 важных условий:

1. Запуск из под суперпользователя **root**.
2. наличие настроенного подключения к интернету в вашем дистрибутиве
3. Установите в Live дистрибутив несколько зависимостей для корректной работы скрипта. Без указанных ниже утилит, скрипт просто не запустится.

$ sudo pacman -Syy ncurses bash dialog python --noconfirm

**Данный скрипт можно запустить из любого места**.
 
Достаточно сделать один из файлов - испольняемым и запустить его из консоли:

```
$ chmod ugo+x aif-installation/aif

$ sudo sh aif-installation/aif
```

Далее просто следуйсте указаниям мастер-установки.

**Желаем вам удачи**.

---

[К оглавлению](#Oglavlenie)

## <a name="Uses">Uses</a>

### Basic information

To use this wizard, you must comply with 2 important conditions:

1. Start from under the superuser **root**.
2. the presence of a configured Internet connection in your distribution
3. Install several dependencies in the Live distribution for the script to work correctly. Without the utilities listed below, the script simply won't run.

$ sudo pacman -Syy ncurses bash dialog python --noconfirm

**This script can be run from anywhere**.

It is enough to make one of the files executable and run it from the console:

```
$ chmod ugo+x aif-installation/aif

$ sudo sh aif-installation/aif
```
Then just follow the instructions of the installation wizard.

**We wish you good luck**.

---

[К оглавлению](#Oglavlenie)

## <a name="aboutrus">Обо Мне</a>

Автор данной разработки **Shadow**: [maximalisimus](https://github.com/maximalisimus).

Имя автора: **maximalisimus**: [E-Mail](mailto:maximalis171091@yandex.ru).

Дата создания: **20.08.2019**

Начальная точка проекта: **Architect Linux installer**.

---

[К оглавлению](#Oglavlenie)

## <a name="abouten">About</a>

The author of this development **Shadow**: [maximalisimus](https://github.com/maximalisimus).

Author's name: **maximalisimus**: [E-Mail](mailto:maximalis171091@yandex.ru).

Date of creation: **20.08.2019**

Starting point of the project: **Architect Linux installer**.


