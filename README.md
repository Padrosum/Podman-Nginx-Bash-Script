# PNBS
Podman aracı ile nginx otomatik konteyner kurulum scripti.

Bildiğiniz üzere podman ile normal bir nginx konteynerı kurulumunda içerisindeki html dosyasını düzenleme işlemleri biraz sıkıntı. Bu yüzden bu script ile 
mevcut home dizininizde nginxin düzenleyebileceğiniz config ve html dosyalarınızı barındıran bir dosya oluşturmakta. Kullanmadan önce scripti incelemeniz önemlidir. Başınıza gelebilecek hiçbir şeyden sorumluluk kabul etmiyorum.


## Kurulum

Önce git aracını dağıtımınızın dökümanlarını okuyarak kurun. Arıdından aşağıdaki kodları yazın.

```
git clone https://github.com/Padrosum/PNBS
chmod +x PNDBS/pdbs.sh
bash PNDBS/pdbs.sh
```

chmod dosya izinlerini değiştirmeye yarıyan bir yazılımdır. Ona verdiğimiz '+x' parametresi sayesinde dasyaya çalıştırabilir yetkisi veriyoruz.
Bash aracı ise .sh dosyalarını çalıştırmayı sağlayan bir CLI yazılımıdır. Dosyamız Bash Script ile yazıldığı için bu aracı kullanıyoruz.

### Lisans 
Halka mal edilmiş yazılım
