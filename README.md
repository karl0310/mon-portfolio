# Karl Bryan — Portfolio

Portfolio en HTML, CSS et JavaScript, connecté à Supabase pour l'administration des réalisations.

## 1. Publication GitHub Pages

1. Ouvre **Settings → Pages** dans le dépôt.
2. Dans **Build and deployment**, sélectionne **GitHub Actions** comme source.
3. Ouvre l'onglet **Actions** et vérifie l'exécution du workflow **Deploy portfolio to GitHub Pages**.
4. Après réussite, le site sera disponible à l'adresse affichée par GitHub Pages, généralement :
   https://karl0310.github.io/mon-portfolio/

Le workflow `.github/workflows/pages.yml` publie le contenu du dépôt à chaque push sur `main`.

## 2. Préparer Supabase

1. Crée un projet Supabase.
2. Dans **SQL Editor**, exécute tout le fichier `supabase/schema.sql`.
3. Dans **Authentication → Users**, crée ton compte administrateur. Désactive l'inscription publique si elle n'est pas nécessaire.
4. Copie l'UUID de cet utilisateur et exécute dans SQL Editor :
   ```sql
   insert into public.portfolio_admins (user_id)
   values ('UUID-DE-TON-UTILISATEUR');
   ```
5. Dans **Project Settings → API**, récupère le Project URL et la clé **Publishable** (ou l'ancienne clé anon).
6. Copie `supabase-config.example.js` vers `supabase-config.js`, puis renseigne ces deux valeurs.

Ne publie jamais la clé `service_role` ou une clé `secret`. Ne partage pas ton mot de passe.

## 3. Administration du portfolio

L'interface `index.html` est maintenant reliée au client Supabase : connexion par e-mail/mot de passe, contrôle du rôle administrateur, création/modification/suppression des projets et téléversement de plusieurs photos par réalisation. Les visiteurs voient uniquement les projets publiés.

Après avoir exécuté `supabase/schema.sql` (y compris l'ajout de `image_urls`), crée le compte dans **Authentication → Users → Add user**. Copie son UUID puis exécute :

```sql
insert into public.portfolio_admins (user_id)
values ('UUID-DE-TON-UTILISATEUR');
```

Le site utilise le Project URL et la clé Publishable configurés dans son script. Cette clé est destinée au navigateur ; la sécurité repose sur les politiques RLS. Ne publie jamais de mot de passe PostgreSQL, de clé `service_role` ou de clé `secret`.

## Fichiers importants

- `index.html` : interface du portfolio.
- `supabase/schema.sql` : tables, accès et politiques de sécurité.
- `supabase-config.example.js` : modèle de configuration publique.
- `.github/workflows/pages.yml` : publication GitHub Pages.
