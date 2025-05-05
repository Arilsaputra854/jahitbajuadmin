const path = require('path');
const express = require('express');

const app = express();
const port = 3000;
const buildPath = path.join(__dirname, "build", "web");

app.use(express.static(buildPath));


app.get("/", (req, res) => {
    res.sendFile(path.join(buildPath, "index.html"));
  });
  
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
