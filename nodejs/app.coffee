express = require 'express'
openssl = require 'openssl-wrapper'
temp = require 'temp'
fs = require 'fs'
_ = require 'underscore'
bodyParser = require 'body-parser'
conf = require '../etc/smtp-signer.conf'
app = express()
app.set 'view engine', 'jade'
app.use(bodyParser.urlencoded({ extended: true, limit: '50mb' })) 
app.use('/bootstrap', express.static(__dirname + '/node_modules/bootstrap/dist/'));
app.use('/jquery', express.static(__dirname + '/node_modules/jquery/dist/'));
app.use('/img', express.static(__dirname + '/img/'));

keys = fs.readdirSync(CERT_DIR)
re = /_all\.pem$/
keys = _.filter(keys, (x) -> x.match(re) )
keys = _.map(keys, (x) -> x.replace("_all.pem","") )

app.get '/', (req,res) ->
  res.render 'index',
    encrypted: "the encrypted content", 
    decrypted: "the decrypted content",
    keys: keys

app.post '/', (req,res) ->
  encrypted = req.body.encrypted
  key = req.body.key
  recip = CERT_DIR+"/"+key+"_all.pem"
  temp.open 'maildecryptor', (err,info) ->
    fs.write info.fd, 'Content-Type: application/pkcs7-mime; name="smime.p7m"; smime-type=enveloped-data"\n\n' if not encrypted.match(/Content-Type:/)
    fs.write info.fd, encrypted
    fs.close info.fd, (err) ->
      opts =
        decrypt: true, 
        in: info.path, 
        recip: recip, 
        passin: 'pass:'+PASSWORD
      openssl.exec 'smime', opts, (err, buffer) ->
        console.log "POST key:"+key
        fs.unlinkSync(info.path)
        res.render 'index',
          encrypted: encrypted, 
          decrypted: buffer.toString() if buffer,
          keys: keys,
          key: key,
          err: "Error: Decryption failed, did you choose a wrong key?" if err

server = app.listen 3000, () ->
  host = server.address().address
  port = server.address().port
  console.log "http://%s:%s", host, port

