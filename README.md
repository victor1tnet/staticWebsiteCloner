# staticWebsiteCloner

Project meant to create a static copy of an online website without direct administrative access to it

### How it's done

- Wget downloads all website files
- Bash and common cli-magic parses the files to be accessible on a different web host
- Uploads to host (currently only github-pages using github api and git)

### Purpose

To make a static copy of a dynamic website (e.g. wordpress blog)
To have an easy way for people to generate a static version of their website without losing features (provided the website has static-friendly alternatives to user interaction, e.g. Disqus for comment system)

### Other uses 

Phishing websites for pentesting (might need some more modification if its used for that)