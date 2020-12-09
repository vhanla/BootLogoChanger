Boot Logo Changer
-----------------

a.k.a. **8oot Logo Changer**
is a Windows 8 and Windows 8.1 boot logo changer tool
for non BIOS UEFI logo mode.

[![](https://1.bp.blogspot.com/-AZv9i_mP5g8/X9C0BqGquZI/AAAAAAAAN-g/4c6XHIbLhqsaswM7MbNBB6KYETAs7DMdgCNcBGAsYHQ/s0/8lc01.png)](https://1.bp.blogspot.com/-AZv9i_mP5g8/X9C0BqGquZI/AAAAAAAAN-g/4c6XHIbLhqsaswM7MbNBB6KYETAs7DMdgCNcBGAsYHQ/s0/8lc01.png)

### Description

With this tool you can change the Windows 8 / Windows 8.1 Boot Logo picture.

# What is it?

8oot Logo Changer is a tool to change Windows 8/Windows 8.1 boot logo with a custom picture, it has the following features:

# Simple editor

You can open or drop any picture in the application and select the area to use as the boot logo.

[![](https://1.bp.blogspot.com/-FvJEU2uXOVw/X9C0hpwk1JI/AAAAAAAAN-o/YbBZJNn3RNcSD-a11YE7_sZdFztCD-SUQCNcBGAsYHQ/s16000/8lc02.png)](https://1.bp.blogspot.com/-FvJEU2uXOVw/X9C0hpwk1JI/AAAAAAAAN-o/YbBZJNn3RNcSD-a11YE7_sZdFztCD-SUQCNcBGAsYHQ/s607/8lc02.png)

[![](https://1.bp.blogspot.com/-cqy5YR5thms/X9C0qYLRBKI/AAAAAAAAN-s/S9ReTTyu4vQ4d3nCzdpIxDS5zKPU5IDiQCNcBGAsYHQ/s16000/8lc03.png)](https://1.bp.blogspot.com/-cqy5YR5thms/X9C0qYLRBKI/AAAAAAAAN-s/S9ReTTyu4vQ4d3nCzdpIxDS5zKPU5IDiQCNcBGAsYHQ/s1024/8lc03.png)

# How to use boot logo editor

Just place any picture in the editor, using the opendialog or dropping a picture, select the area and create the bitmaps with button **[>]**

After that, generate the bootres.dll file, it will be located in a temporary folder (inside AppData).

Once ready, Apply it, it will ask you to install a local test certificate that it needs to be present since bootres.dll requires a valid certificate to be loaded at boot time. Just cancel when asked for Smart Card and then accept to install that local test certificate. **This will only ask once.**

[![](https://1.bp.blogspot.com/-S-Efs00z37M/X9C1BSjq5ZI/AAAAAAAAN-0/ItpiyQv-LkUW3zEhIYJeoAqyrENJG0ezgCNcBGAsYHQ/s16000/8lc04.png)](https://1.bp.blogspot.com/-S-Efs00z37M/X9C1BSjq5ZI/AAAAAAAAN-0/ItpiyQv-LkUW3zEhIYJeoAqyrENJG0ezgCNcBGAsYHQ/s439/8lc04.png)

[![](https://1.bp.blogspot.com/-5JivlFy77m4/X9C1FnEwIqI/AAAAAAAAN-4/KKKlkyh2ySYQwelyg9fGQu0WNGGGdOd3gCNcBGAsYHQ/s16000/8lc05.png)](https://1.bp.blogspot.com/-5JivlFy77m4/X9C1FnEwIqI/AAAAAAAAN-4/KKKlkyh2ySYQwelyg9fGQu0WNGGGdOd3gCNcBGAsYHQ/s496/8lc05.png)

# Watermark remover

As this tool requires you to set TESTSIGNING mode ON in order to be able to show the new boot logo at boot, Windows will show a watermark in the bottom part of your screen, so it includes a patcher that will modify two MUI files : shell32.dll.mui and basebrd.dll.mui

[![](https://1.bp.blogspot.com/-yWMil6S4YUA/X9C1Nqj2YwI/AAAAAAAAN-8/wwvuqbD3Smk_zrSY1eBL9bOPPwwjY6QtACNcBGAsYHQ/s0/8lc06.png)](https://1.bp.blogspot.com/-yWMil6S4YUA/X9C1Nqj2YwI/AAAAAAAAN-8/wwvuqbD3Smk_zrSY1eBL9bOPPwwjY6QtACNcBGAsYHQ/s270/8lc06.png)

[![](https://1.bp.blogspot.com/-UbYPQOu7Y4E/X9C1SpbDeXI/AAAAAAAAN_E/_Ij-W8-irQIvOb4GGYcAPD-5dSyb5jAbgCNcBGAsYHQ/s0/8lc07.png)](https://1.bp.blogspot.com/-UbYPQOu7Y4E/X9C1SpbDeXI/AAAAAAAAN_E/_Ij-W8-irQIvOb4GGYcAPD-5dSyb5jAbgCNcBGAsYHQ/s270/8lc07.png)

[![](https://1.bp.blogspot.com/-Tg_WO9ubDOg/X9C1YJS5WbI/AAAAAAAAN_M/oxGjA6P88L4CH0x8KH97vCgtKa2hXdQOwCNcBGAsYHQ/s16000/8lc08.png)](https://1.bp.blogspot.com/-Tg_WO9ubDOg/X9C1YJS5WbI/AAAAAAAAN_M/oxGjA6P88L4CH0x8KH97vCgtKa2hXdQOwCNcBGAsYHQ/s617/8lc08.png)

[![](https://1.bp.blogspot.com/-v7RuoCPqx-Y/X9C1b7EUfjI/AAAAAAAAN_Q/p0Ym2SteeBQXXu2cnOu5JCAvxbHirw1SwCNcBGAsYHQ/s16000/8lc09.png)](https://1.bp.blogspot.com/-v7RuoCPqx-Y/X9C1b7EUfjI/AAAAAAAAN_Q/p0Ym2SteeBQXXu2cnOu5JCAvxbHirw1SwCNcBGAsYHQ/s617/8lc09.png)

# What does it exactly do?

### Patching Bootlogo

It replaces 6 BMP files inside **bootres.dll**, those pictures have fixed in size and are 24bit in depth. The application adjusts the picture you select according to those sizes and changes 32bit to 24bit if necessary. After that it replaces those pictures inside bootres.dll.

When Applying those changes, it requires you to make a backup (which will be located inside Windows folder), that backup is the original bootres.dll file.

### Patching MUI Files

There are two files that we need to modify in order to hide the watermark shown by Windows in TEST MODE.

· **shell32.dll.mui** is located inside your system32 directory, specifically inside a localization folder (e.g. en-US), this file has resource string table which is used to show that message in the desktop, so this tool will make those changes for you.

* * *

· **basebrd.dll.mui** is another file which is located inside Windows\Branding\Basebrd folder inside the localization folder. And it also holds part of the message that Windows shows as a watermark when we are in Testsigning mode on.

As you can see in the picture, it will show those messages in the tool (visible if not patched).

[![](https://1.bp.blogspot.com/-AvCF5vOmDDY/X9C1hSOePpI/AAAAAAAAN_Y/BCRYkNAd0LU1gLkPCuRGy_-Ph-4oqwKLACNcBGAsYHQ/s16000/8lc10.png)](https://1.bp.blogspot.com/-AvCF5vOmDDY/X9C1hSOePpI/AAAAAAAAN_Y/BCRYkNAd0LU1gLkPCuRGy_-Ph-4oqwKLACNcBGAsYHQ/s617/8lc10.png)

### Conclusion

Those are the changes that this tool does:

If you like to read more and do it mannually, you can always follow the tutorial at Winmatrix by Krutonium ~> [read it](http://web.archive.org/web/20131207110308/http://www.winmatrix.com/forums/index.php?/topic/36724-windows-8-custom-boot-logo/?p=321171).

* * *

# Pros

*   Auto adjusts the bitmap size.
*   A simple previewer that might help you decide which picture to use.
*   Reversible, any changes can be undone.

# Cons

*   Tested only on Windows 8/8.1 Pro x64.
*   It might present incompatibilities with other MUI patchers.
*   UEFI not supported.

# Requirements

*   Windows 8 / Windows 8.1
*   5MB RAM minimum:
*   Disk Space: 8MB

* * *

