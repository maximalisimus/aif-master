# aif-master

---

* [Russian Text](#Russian)
* [English Text](#English)

<a name="Russian"></a>

aif-master - Bash скрипт для установки системы Archlinux с нуля на компьютер или виртуальную машину.

<a name="Oglavlenie"></a>

## Оглавление

1. [Обзор.](#Overview)
	1. [Введение.](#Information)
	2. [Зависимости.](#Depends)
2. [Использование](#Uses)
	1. [Использование без установки.](#NotInstalled)
	2. [Использование с установкой.](#Installed)
3. [Об авторе.](#About)

## <a name="Overview">1. Обзор.</a>

### <a name="Information">1.1. Введение.</a>

Данный скрипт предназначен для установки системы **Archlinux** в псевдографическом режиме, 
с помощью утилиты **dialog**.

Скрипт можно использовать с абсолютно любым дистрибутивом *Archlunux*, кроме **bootstrap** и **arm** версии. 

Данный мастер поддерживает **UEFI** режим установки при запуске системы *ArchLinux* в режиме *UEFI*.

Данному установщику **не нужен** ни **XORG**, ни рабочее окружение ( **Desktop environment** ), ни дисплейный менеджер 
( **Display Manager** ). Данный скрипт работает полностью в консольном режиме. 

Для работы скрипта необходим следующий список пакетов:

* arch-install-scripts
* dialog
* ncurses
* lib32-ncurses
* parted
* util-linux
* gptfdisk
* pacman-contrib
* python (2 или 3)
* wget
* curl

Вы можете использовать данный мастер установки для самых разных режимов использования системы ArchLinux.

Например, не устанавливать графическую часть (XORG, Desktop Environment, Display Manager, драйвер видеокарты и другие), 
чтобы использовать в качестве сервера.

Или выбрать и установить только необходимые пакеты и использовать в качестве Настольного ПК.
Независимо от местоположения вашего компьютера - будь то офис или домашний ПК.

---

[К оглавлению](#Oglavlenie)

## <a name="Uses">2. Использование</a>

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

## <a name="about">3. Обо Мне</a>

Автор данной разработки **Shadow**: [maximalisimus](https://github.com/maximalisimus).

Имя автора: **maximalisimus**: [E-Mail](mailto:maximalis171091@yandex.ru).

Дата создания: **20.08.2019**

Начальная точка проекта: **Architect Linux installer**.

---

[К оглавлению](#Oglavlenie)

---

<a name="English"></a>

<a name="EngOglavlenie"></a>

air-master - Bash script for installing the Archlinux system from scratch on a computer.

![Application](./image/aif-image.png "aif-master")

## Table of contents

1. [Information](#EngInformation)
2. [Uses](#EngUses)
3. [About](#Engabout)

## <a name="EngInformation">1. Information</a>



---

[To the table of contents](#EngOglavlenie)

## <a name="Engabout">3. About</a>

The author of this development **Shadow**: [maximalisimus](https://github.com/maximalisimus).

Author's name: **maximalisimus**: [E-Mail](mailto:maximalis171091@yandex.ru).

Date of creation: **20.08.2019**

Starting point of the project: **Architect Linux installer**.

---

[To the table of contents](#EngOglavlenie)

