aws_install_key () { 
cat $1 | openssl enc -md sha256 -aes-256-cbc -a -d > ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519
sudo chown cloudshell-user:cloudshell-user ~/.ssh/id_ed25519
}

aws_github_install_key () { 
mkdir ~/.ssh/

aws_install_key << EndOfMessage
U2FsdGVkX19zo9s4dznIx1o/qvh9ztCTmzcqtAKKAlhFkiVbfcf2hulSTrb4++QZ
QQ978RMen49/u5j7xUcqc8ho6BXa2tykY7gU6tQ9Wwd4U88ktrR5GjSISdJJMhjx
qBmO7RdIZQnZ5ZgCHQQgXHL3ipL954K93UOowcMLhkasBBQmI8iTiOfBhT6KYGXg
gmXm5zGuFRnC1AZgPFgA1gaqNxvqllkCRyZka7ffeg8/14YbKREbBHrsnoBlekN4
GkGJFml/2weAlF0Ow4S0R/P6x0Uufe+rNni3sNM9Rez5e4le0geXR9UtTo+eJhJH
91PTrEt0FsZgRCKh6NkNmq3de67+XQpuFzi5ymikxoBuY8N6LfMdvcpmS5Dov76T
ik3TJfhbB62zd0roCYJ1XP8w12Z5Vnr+5yAdcIQhQbLicYOzJkiqaHBp+DqkFDIw
AzmfKAq0lNH15VMrdHXSU7576/tSTeDbJoRfjRVy0qjWoV/9GXeXnz9vRsPb+Bta
4dsRV0bLZaLXPc5c6gHuTblhRkylXIU2Rje98AFQNNK8/5lbqxglZglVBcAxnsfB
jfELs+99Caz59815wIfSu1O0I7xbftrrxJWJZ+2hZDN2fpR975e93Vp8UGHYc1It
VyQqrbtHRwB2cMj2IBA14g==
EndOfMessage
}

aws_github_install_key