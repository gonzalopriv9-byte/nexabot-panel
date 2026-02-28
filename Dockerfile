# Simple web server
FROM node:18-alpine

WORKDIR /app

# Copy all files
COPY . .

# Expose port (Render uses this)
EXPOSE 3000

# Simple HTTP server using node
CMD ["node", "-e", "const http = require('http'); const fs = require('fs'); http.createServer((req, res) => { res.writeHead(200, {'Content-Type': 'text/html'}); res.end('<h1>NexaBot Panel</h1><p>Service is running</p>'); }).listen(3000, () => console.log('Server running on port 3000')); "]
