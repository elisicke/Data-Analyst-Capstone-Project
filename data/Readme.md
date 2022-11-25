Auszug Nutzerdaten sind gemäss NDA vertraulich zu behandeln und dürfen nicht an Dritte weitergegeben werden.

# accounts.csv
Benutzerkonten mit Einzelmieten oder Abos im Zeitraum 1.10.2020 bis 1.10.2022

- Account_Key: Eindeutiger Key für jedes Benutzerkonto
- Postal_Code: Postleitzahl (Benutzerangabe bei Registrierung)
- City: Ort (Benutzerangabe bei Registrierung)
- Language: Sprachwahl UI (de/fr/en)
- Country_Code: Ländercode (Benutzerangabe bei Registrierung)
- Onetime_Rental_Count: Anzahl Einzelmieten im betrachteten Zeitraum
- Subscription_Count: Anzahhl Abos im betrachteten Zeitraum

# subscriptions.csv: Streaming-Abos
Streaming-Abos mit Ablaufdatum nach dem 1.10.2020

- Subscription_Key: Eindeutiger Key für jedes Abo
- Account_id: Key zugeordnetes Benutzerkonto
- Currency: Währung Schweizer Franken (chf) oder Euro (eur)
- Price: Preis pro Monat bzw. Jahr
- Subscription_Type: BASIC (Filmfriend), STANDARD (Filmfan) oder PATRON (Filmlover)
- Subscription_Monthly: Monatsabo (1) oder Jahresabo (0)
- Subscription_Start: Abo-Beginn
- Subscription_End: Abo-Ende
- Gift_Subscription: Eingelöster Geschenkgutschein (true) oder reguläres Abo (false)

# playback.csv: Abgespielte Filme mit Abo
Abgespielte Filme im Zeitraum 1.10.2020 bis 1.10.2022

- Account_Key: Key zugeordnetes Benutzerkonto
- Subscription_Key: Key zugeordnetes Abo
- Movie_ID: Eindeutiger Key für jeden Film
- Date_Start: Abspieldatum/-zeit
- Playback_Time: Abspieldauer in Sekunden
- User_Agent: User Agent Browser oder Version filmingo-App (iOS, Android, blueTV)
- IP_Hash: Hashwert IP Adresse
