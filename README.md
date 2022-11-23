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

Псевдографика - совокупность символов, включённых в набор символов компьютерного шрифта, отображающих графические примитивы (линии, прямоугольники, треугольники, кресты,
различная запивка и тому подобное).

Основное назначение псевдографики — графическое оформление программ с текстовым интерфейсом пользователя (в том числе и так называемых консольных) — отображение в них окон, меню, кнопок и прочих элементов интерфейса, без создания самих окон как таковых. Т.е. при отсутствии графической оболочки.

По умолчанию в любом образе **Archlinux** нет графической оболочки как таковой. Чтобы решить такую проблему используется специальный пакет, который как бы имитирует окна и поведение в них, отслеживая нажатие клавиш на клавиатуре - влево, вправо, вверх, вниз, пробел, Энтер, Эскейп, и другие, включая любые символы текста.

Вот так может выглядеть окно с самым простым вопросом, на который можно ответить только да или нет.

<img src="https://github.com/maximalisimus/aif-master/blob/master/image/else-scr/yesno.png">

С помощью таких вот псевдо-окон и происходит обработка выбранный пользователем действий. Всё остальное скрыто от глаз пользователя, т.е. обработка происходит незримо для пользователя и в автоматическом режиме.

Вот так выглядит окно при запуске данного скрипта установщика.

<img src="https://github.com/maximalisimus/aif-master/blob/master/image/scr-1-50/scr-3.png">  

Естественно перед этим окном пользователей в обязательном порядке спрашивают какой язык нтерфейса для этого скрипта применить. В данном случае, на выбор предлагается 11 языков.

<img src="https://github.com/maximalisimus/aif-master/blob/master/image/scr-1-50/scr-1.png">

Скрипт можно использовать с абсолютно любым дистрибутивом **Archlunux**, кроме **bootstrap** и **arm** версии. 

Данный скрипт поддерживает **UEFI** режим установки, если вы вдруг запустили систему **ArchLinux** в режиме **UEFI**.

Такому скрипту **не нужен** ни **XORG**, ни рабочее окружение ( **Desktop environment** ), ни дисплейный менеджер 
( **Display Manager** ). Потому что он работает полностью в консольном режиме, т.е. без графической оболочки.

В случае если у вас уже есть графическая оболочка. Ничего страшного. 
Скрипту понадобятся пару дополнительных пакетов и он по прежнему будет работать в консоле без окон как таковых.

Вы можете использовать данный мастер установки для самых разных целей использования системы **ArchLinux**.

Например, не устанавливать графическую часть (**XORG**, **Desktop Environment**, **Display Manager**, драйвер видеокарты и другие), 
чтобы использовать систему в качестве сервера.

Или выбрать и установить только необходимые пакеты и использовать в качестве Настольного ПК, независимо от местоположения вашего компьютера - будь то офис или домашний ПК.

---

[К оглавлению](#Oglavlenie)

---

### <a name="Depends">1.2. Зависимости.</a>

Для работы скрипта необходим следующий список пакетов:

* arch-install-scripts
* dialog
* ncurses
* lib32-ncurses
* util-linux
* pacman-contrib
* python
* wget
* curl
* sed
* gawk
* grep
* parted
* gptfdisk

**Без этих пакетов скрипт может вообще не запуститься или работать некорректно! Рекомендуется установить все пакеты без исключения.**

Для установки этих пакетов воспользуйтесь следующей командой:

``` bash
sudo pacman -Syy archlinux-keyring arch-install-scripts dialog ncurses lib32-ncurses util-linux pacman-contrib python wget curl sed gawk grep parted gptdisk --noconfirm
```

---

[К оглавлению](#Oglavlenie)

---

## <a name="Uses">2. Использование.</a>

Для использования данного мастера необходимо соблюдать 3 важных условия:

1. Запуск из под суперпользователя **root**.
2. наличие настроенного подключения к интернету в вашем дистрибутиве
3. Установите в Live дистрибутив несколько зависимостей для корректной работы скрипта. Без указанных выше утилит, скрипт может не запуститься или работать некорректно.

Для установки зависимостей перейдите [к этому параграфу](#Depends).

### <a name="NotInstalled">2.1. Использование без установки.</a>

Для использования скрипта без установки понадобится утилита **Git**, которой по умолчанию нет в стандартном диструбутиве **ArchLinnux**.

``` bash
sudo pacman -Syy git --noconfirm
```

**Данный скрипт можно запустить из любого места**.
 
Достаточно сделать два файла - испольняемыми и запустить один из них из консоли от прав суперпользователя:

``` bash
$ git clone https://github.com/maximalisimus/aif-master.git
$ cd aif-master
$ chmod ugo+x ./aif ./config/list_in_list.py
$ sudo sh ./aif
```

Далее просто следуйсте указаниям появившегося меню. Для более точного руководства воспользуйтесь нашей [Wiki](https://github.com/maximalisimus/aif-master/wiki), где вы сможете получить ответы на большинство вопросов касательно не только данного скрипта.

---

[К оглавлению](#Oglavlenie)

---

### <a name="Installed">2.2. Использование с установкой.</a>

Чтобы воспользоваться запуском скрипта с установкой скачайте готовый пакет из последней доступной [**Release** версии](https://github.com/maximalisimus/aif-master/releases) скрипта.

После того как скачаете пакет, его необходимо установить. Кстати, скачать можно прямо из консоли, не открывая барузер.

``` bash
$ wget https://github.com/maximalisimus/aif-master/releases/download/vx.x-x/aif-master-x.x-x-any.pkg.tar.zzz
$ sudo pacman -U ./aif-master-x.x-x-any.pkg.tar.zzz --nocnfirm
```

Где **«x.x-x»** — это версия и выпуск в двух местах, а **«zzz»** на конце — это расширение пакета в зависимости от версии. В старых версиях это **«xz»**, а в новых — **«zst»**.

После установки запустить можно следующей командой.

``` bash
$ aif-master
# или
$ /usr/bin/aif-master
```

Также, в главном меню в категории **«Утилиты»** имеется ярлык для запуске скрипта от имени суперпользователя.

Далее просто следуйсте указаниям появившегося меню. Для более точного руководства воспользуйтесь нашей [Wiki](https://github.com/maximalisimus/aif-master/wiki), где вы сможете получить ответы на большинство вопросов касательно не только данного скрипта.

---

[К оглавлению](#Oglavlenie)

---

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

aif-master - Bash script for installing the Archlinux system from scratch on a computer or virtual machine.

## Table of contents

1. [Review.](#EngOverview)
	1. [Introduction.](#EngInformation)
	2. [Dependencies.](#EngDepends)
2. [Using](#EngUses)
	1. [Use without installation.](#EngNotInstalled)
	2. [Use with installation.](#EngInstalled)
3. [Об авторе.](#EngAbout)

## <a name="EngOverview">1. Review</a>

### <a name="EngInformation">1.1. Introduction.</a>

This script is designed to install the **Archlinux** system in pseudographic mode,
using the **dialog** utility.

Pseudographics is a set of symbols included in a set of computer font symbols that display graphic primitives (lines, rectangles, triangles, crosses,
various bindings, and the like).

The main purpose of pseudo—graphics is the graphical design of programs with a text user interface (including the so—called console ones) - displaying windows, menus, buttons and other interface elements in them, without creating windows themselves as such. I.e. in the absence of a graphical shell.

By default, there is no graphical shell as such in any **Archlinux** image. To solve this problem, a special package is used that simulates windows and behavior in them, tracking keystrokes on the keyboard - left, right, up, down, space, Enter, Escape, and others, including any text characters.

This is how a window with the simplest question can look like, which can only be answered with yes or no.

<img src="https://github.com/maximalisimus/aif-master/blob/master/image/else-scr/yesno.png">

With the help of such pseudo-windows, the actions selected by the user are processed. Everything else is hidden from the user's eyes, i.e. processing takes place invisibly for the user and in automatic mode.

This is how the window looks when running this installer script.

<img src="https://github.com/maximalisimus/aif-master/blob/master/image/scr-1-50/scr-3.png">  

Naturally, before this window, users are necessarily asked which interface language to use for this script. In this case, there are 11 languages to choose from.

<img src="https://github.com/maximalisimus/aif-master/blob/master/image/scr-1-50/scr-1.png">

The script can be used with absolutely any **Archlunux** distribution, except **bootstrap** and **arm** versions. 

This script supports **UEFI** installation mode, if you suddenly started the **ArchLinux** system in **UEFI** mode.

Such a script ** does not need ** neither **XORG**, nor a working environment (**Desktop environment**), nor a display manager 
( **Display Manager** ). Because it works completely in console mode, i.e. without a graphical shell.

In case you already have a graphical shell. It's not a big deal. 
The script will need a couple of additional packages and it will still work in the console without windows as such.

You can use this installation wizard for a variety of purposes using the **ArchLinux** system.

For example, do not install the graphics part (**XORG**, **Desktop Environment**, **Display Manager**, video card driver and others)
to use the system as a server.

Or choose and install only the necessary packages and use it as a Desktop PC, regardless of the location of your computer - be it an office or a home PC.

---

[To the table of contents](#EngOglavlenie)

---

### <a name="EngDepends">1.2. Dependencies.</a>

The following list of packages is required for the script to work:

* arch-install-scripts
* dialog
* ncurses
* lib32-ncurses
* util-linux
* pacman-contrib
* python
* wget
* curl
* sed
* gawk
* grep
* parted
* gptfdisk

**Without these packages, the script may not start at all or work incorrectly! It is recommended to install all packages without exception.**

To install these packages, use the following command:

``` bash
sudo pacman -Syy archlinux-keyring arch-install-scripts dialog ncurses lib32-ncurses util-linux pacman-contrib python wget curl sed gawk grep parted gptdisk --noconfirm
```

---

[To the table of contents](#EngOglavlenie)

---

## <a name="EngUses">2. Using.</a>

To use this wizard, you must comply with 3 important conditions:

1. Run from under the superuser **root**.
2. the presence of a configured Internet connection in your distribution
3. Install several dependencies in the Live distribution for the script to work correctly. Without the above utilities, the script may not start or work incorrectly.

To install dependencies, go to [to this paragraph](#EngDepends).

### <a name="EngNotInstalled">2.1. ИUse without installation.</a>

To use the script without installation, you will need the **Git** utility, which is not available by default in the standard distrubutive **ArchLinnux**.

``` bash
sudo pacman -Syy git --noconfirm
```

**This script can be run from anywhere**.
 
It is enough to make two executable files and run one of them from the console from superuser rights:

``` bash
$ git clone https://github.com/maximalisimus/aif-master.git
$ cd aif-master
$ chmod ugo+x ./aif ./config/list_in_list.py
$ sudo sh ./aif
```

Then just follow the instructions of the menu that appears. For a more accurate guide, use our [Wiki](https://github.com/maximalisimus/aif-master/wiki), where you can get answers to most of the questions about not only this script.

---

[To the table of contents](#EngOglavlenie)

---

### <a name="EngInstalled">2.2. Use with installation.</a>

To use the launch of the script with the installation, download the finished package from the latest available [**Release** versions](https://github.com/maximalisimus/aif-master/releases) the script.

After you download the package, you need to install it. By the way, you can download it directly from the console without opening the browser.

``` bash
$ wget https://github.com/maximalisimus/aif-master/releases/download/vx.x-x/aif-master-x.x-x-any.pkg.tar.zzz
$ sudo pacman -U ./aif-master-x.x-x-any.pkg.tar.zzz --nocnfirm
```

Where **«x.x-x»** — this is a version and release in two places, and **«zzz»** at the end is an extension of the package depending on the version. In older versions it is **«xz»**, and in the new ones — **«zst»**.

After installation, you can run the following command.

``` bash
$ aif-master
# или
$ /usr/bin/aif-master
```

Also, in the main menu in the category **"Utilities"** there is a shortcut for running the script on behalf of the superuser.

Then just follow the instructions of the menu that appears. For a more accurate guide, use our [Wiki](https://github.com/maximalisimus/aif-master/wiki), where you can get answers to most of the questions about not only this script.

---

[To the table of contents](#EngOglavlenie)

---

## <a name="EngAbout">3. About</a>

The author of this development **Shadow**: [maximalisimus](https://github.com/maximalisimus).

Author's name: **maximalisimus**: [E-Mail](mailto:maximalis171091@yandex.ru).

Date of creation: **20.08.2019**

Starting point of the project: **Architect Linux installer**.

---

[To the table of contents](#EngOglavlenie)

