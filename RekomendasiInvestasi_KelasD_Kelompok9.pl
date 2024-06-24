% Prolog

% Fakta
resiko(rendah).
resiko(sedang).
resiko(tinggi).

jangka_waktu(pendek).
jangka_waktu(menengah).
jangka_waktu(panjang).

tujuan(pensiun).
tujuan(membeli_rumah).

jumlah_dana(sedang).
jumlah_dana(besar).

pengalaman(menengah).
pengalaman(ahli).

investasi(saham).
investasi(obligasi).
investasi(deposito).
investasi(reksa_dana).
investasi(properti).

% Predikat dinamis untuk jawaban pengguna dan keyakinan
:- dynamic pengguna_resiko/1.
:- dynamic pengguna_jangka_waktu/1.
:- dynamic pengguna_tujuan/1.
:- dynamic pengguna_jumlah_dana/1.
:- dynamic pengguna_pengalaman/1.

:- dynamic keyakinan_resiko/1.
:- dynamic keyakinan_jangka_waktu/1.
:- dynamic keyakinan_tujuan/1.
:- dynamic keyakinan_jumlah_dana/1.
:- dynamic keyakinan_pengalaman/1.

% Aturan rekomendasi investasi
rekomendasi(deposito) :- pengguna_resiko(0.1), pengguna_jangka_waktu(0.1).
rekomendasi(obligasi) :- pengguna_resiko(0.5), pengguna_jangka_waktu(0.5).
rekomendasi(reksa_dana) :- pengguna_resiko(1), pengguna_jangka_waktu(1).
rekomendasi(properti) :- pengguna_tujuan(0.1), pengguna_jumlah_dana(1).
rekomendasi(saham) :- pengguna_tujuan(1), pengguna_pengalaman(1).

% Menghitung nilai keyakinan untuk setiap investasi
hitungan_keyakinan(Investasi, Keyakinan) :-
    pengguna_resiko(UR), pengguna_jangka_waktu(UJ), pengguna_tujuan(UT), pengguna_jumlah_dana(UD), pengguna_pengalaman(UP),
    (rekomendasi(Investasi) ->
        (   Investasi = deposito, KR = 0.1, KJ = 0.2, KT = 0.3, KJD = 0.4, KP = 0.5;
            Investasi = obligasi, KR = 0.2, KJ = 0.3, KT = 0.4, KJD = 0.5, KP = 0.6;
            Investasi = reksa_dana, KR = 0.3, KJ = 0.4, KT = 0.5, KJD = 0.6, KP = 0.7;
            Investasi = properti, KR = 0.4, KJ = 0.5, KT = 0.6, KJD = 0.7, KP = 0.8;
            Investasi = saham, KR = 0.5, KJ = 0.6, KT = 0.7, KJD = 0.8, KP = 0.9
        ),
        K1 is KR * UR,
        K2 is KJ * UJ,
        K3 is KT * UT,
        K4 is KJD * UD,
        K5 is KP * UP,
        Keyakinan is (K1 + K2 + K3 + K4 + K5) / 5
    ).

% Pertanyaan kepada pengguna
tanya_resiko :-
    write('Apakah Anda ingin investasi dengan risiko rendah(1), sedang(2), tinggi(3)? '), nl,
    read(R), 
    (R == 1 -> assert(pengguna_resiko(0.1)), assert(keyakinan_resiko(0.1));
     R == 2 -> assert(pengguna_resiko(0.5)), assert(keyakinan_resiko(0.5));
     R == 3 -> assert(pengguna_resiko(1)), assert(keyakinan_resiko(1));
     write('Pilihan risiko tidak valid.'), nl, fail).

tanya_jangka_waktu :-
    write('Apakah Anda ingin investasi untuk jangka waktu pendek(1), menengah(2), panjang(3)? '), nl,
    read(J),
    (J == 1 -> assert(pengguna_jangka_waktu(0.1)), assert(keyakinan_jangka_waktu(0.1));
     J == 2 -> assert(pengguna_jangka_waktu(0.5)), assert(keyakinan_jangka_waktu(0.5));
     J == 3 -> assert(pengguna_jangka_waktu(1)), assert(keyakinan_jangka_waktu(1));
     write('Pilihan jangka waktu tidak valid.'), nl, fail).

tanya_tujuan :-
    write('Apa tujuan investasi Anda (pensiun(1), membeli_rumah(2))? '), nl,
    read(T),
    (T == 1 -> assert(pengguna_tujuan(0.1)), assert(keyakinan_tujuan(0.1));
     T == 2 -> assert(pengguna_tujuan(1)), assert(keyakinan_tujuan(1));
     write('Pilihan tujuan tidak valid.'), nl, fail).

tanya_jumlah_dana :-
    write('Berapa jumlah dana yang akan diinvestasikan (sedang(1), besar(2))? '), nl,
    read(D),
    (D == 1 -> assert(pengguna_jumlah_dana(0.5)), assert(keyakinan_jumlah_dana(0.5));
     D == 2 -> assert(pengguna_jumlah_dana(1)), assert(keyakinan_jumlah_dana(1));
     write('Pilihan jumlah dana tidak valid.'), nl, fail).

tanya_pengalaman :-
    write('Seberapa berpengalaman Anda dalam berinvestasi (menengah(1), ahli(2))? '), nl,
    read(P),
    (P == 1 -> assert(pengguna_pengalaman(0.5)), assert(keyakinan_pengalaman(0.5));
     P == 2 -> assert(pengguna_pengalaman(1)), assert(keyakinan_pengalaman(1));
     write('Pilihan pengalaman tidak valid.'), nl, fail).

% Sistem rekomendasi
rekomendasi_investasi :-
    tanya_resiko, tanya_jangka_waktu, tanya_tujuan, tanya_jumlah_dana, tanya_pengalaman,
    findall((Investasi, Keyakinan), hitungan_keyakinan(Investasi, Keyakinan), RekomendasiList),
    write('Rekomendasi investasi dan nilai keyakinan Anda adalah: '), nl,
    print_rekomendasi(RekomendasiList).

print_rekomendasi([]).
print_rekomendasi([(Investasi, Keyakinan)|T]) :-
    write('Investasi: '), write(Investasi), write(' - Keyakinan: '), write(Keyakinan), nl,
    print_rekomendasi(T).

% Menjalankan sistem rekomendasi
:- rekomendasi_investasi.




