# Karl Bryan — Portfolio

Portfolio statique en HTML, CSS et JavaScript, hébergé avec GitHub Pages.

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

## 3. État de l'intégration

Le schéma de base de données, les règles RLS et le bucket d'images sont préparés. L'interface de `index.html` utilise encore son ancien stockage local : elle n'est pas encore connectée à Supabase. L'authentification et les opérations CRUD devront être reliées au client Supabase avant de considérer l'administration comme opérationnelle.

## Fichiers importants

- `index.html` : interface du portfolio.
- `supabase/schema.sql` : tables, accès et politiques de sécurité.
- `supabase-config.example.js` : modèle de configuration publique.
- `.github/workflows/pages.yml` : publication GitHub Pages.
