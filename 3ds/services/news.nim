#
# Requires access to "news:u" service.
#

proc newsInit*(): Result = 0
proc newsExit*(): Result
# NEWSU_AddNotification()
#About: Adds a notification to the home menu Notifications applet.
#
#  title	UTF-16 title of the notification.
#  titleLength	Number of characters in the title, not including the null-terminator.
#  title	UTF-16 message of the notification, or NULL for no message.
#  titleLength	Number of characters in the message, not including the null-terminator.
#  image	Data of the image to show in the notification, or NULL for no image.
#  imageSize	Size of the image data in bytes.
#  jpeg		Whether the image is a JPEG or not.
#

proc NEWSU_AddNotification*(title: ptr u16; titleLength: u32; message: ptr u16;
                           messageLength: u32; imageData: pointer; imageSize: u32;
                           jpeg: bool): Result
