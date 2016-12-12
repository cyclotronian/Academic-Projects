#include<linux/module.h>
#include<linux/string.h>
#include<linux/fs.h>
#include<asm/uaccess.h>
#include<linux/fcntl.h>
#include<linux/unistd.h>
#include <asm/segment.h>
#include <asm/uaccess.h>
#include <linux/buffer_head.h>

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Device Driver Demo");
MODULE_AUTHOR("Group_8");

static int times=0;
char ch[2];
struct file *fhandle_brightness, *fhandle_mouse;
int left,right;

static int dev_open(struct inode *,struct file *);
static int dev_rls(struct inode *,struct file *);
static ssize_t dev_read(struct file *,char *, size_t,loff_t *);
static  ssize_t dev_write(struct file *,const char *,size_t,loff_t *);

static struct file_operations fops =
{
    .read = dev_read,
    .open = dev_open,
    .write= dev_write,
    .release= dev_rls,
};

struct file* file_open(const char* path, int flags, int rights) {
     struct file* filp = NULL;
    mm_segment_t oldfs;
    int err = 0;
     oldfs = get_fs();
    set_fs(get_ds());
    filp = filp_open(path, flags, rights);
    set_fs(oldfs);
    if(IS_ERR(filp)) {
         err = PTR_ERR(filp);
        return NULL;
    }
     return filp;
}

void file_close(struct file* file) {
     filp_close(file, NULL);
}

int file_read(struct file* file, unsigned long long offset, unsigned char* data, unsigned int size) {
     mm_segment_t oldfs;
    int ret;
     oldfs = get_fs();
    set_fs(get_ds());
     ret = vfs_read(file, data, size, &offset);
     set_fs(oldfs);
    return ret;
}

int file_write(struct file* file, unsigned long long offset, unsigned char* data, unsigned int size) {
     mm_segment_t oldfs;
    int ret;
     oldfs = get_fs();
    set_fs(get_ds());
     ret = vfs_write(file, data, size, &offset);
     set_fs(oldfs);
    return ret;
}

int init_module(void)
{
         int t = register_chrdev(89,"myfirst",&fops);
      if(t<0) printk(KERN_ALERT "device registration failed .. \n");
      else printk(KERN_ALERT "device registered.. \n");
      return t;
}

void cleanup_module(void)
{
        unregister_chrdev(89,"myfirst");
}
static int dev_open(struct inode *inod,struct file *fil)
{
         times++;
         printk(KERN_ALERT "device opened %d times\n",times);
         //printk("yoyoyo");
         return 0;
}

static ssize_t dev_read(struct file *filp, char *buff,size_t len,loff_t *off)
{
       fhandle_brightness = file_open("/sys/class/backlight/acpi_video0/brightness", 0, 0);
       file_read((struct file*)fhandle_brightness, 0, ch, 1);
       
       fhandle_mouse = file_open("/dev/input/mice",0, 0);
       file_read(fhandle_mouse,0,buff,1);
       
            left = buff[0] & 0x1;
            right = buff[0] & 0x2;
            
       if(ch[0] == '0'){
           if(left>0)
                ch[0] = '0';
           else if(right>0)
                ch[0] = (char)(((int)ch[0]-'0'+1)+'0');
       }
       else if(ch[0] == '9'){
           if(left>0)
                ch[0] = (char)(((int)ch[0]-'0'-1)+'0');
           else if(right > 0)
                ch[0] = '9';
       }
       else{
           if(left > 0){
                ch[0] = (char)(((int)ch[0]-'0'-1)+'0');       
           }
           else if(right > 0){
                ch[0] = (char)(((int)ch[0]-'0'+1)+'0');
           }
       }     
       printk(ch);
       file_close((struct file*)fhandle_brightness);
       file_close((struct file*)fhandle_mouse);
       fhandle_brightness = file_open("/sys/class/backlight/acpi_video0/brightness", 1, 0);  
       file_write((struct file*)fhandle_brightness, 0, ch, 1);
       file_close((struct file*)fhandle_brightness);
       return 0;
}

static ssize_t dev_write(struct file *filp,const char *buff,size_t len,loff_t *off)
{
    return 0;
}


static int dev_rls(struct inode *inod,struct file *fil)
{
     printk(KERN_ALERT "device closed\n");
     return 0;
}   











