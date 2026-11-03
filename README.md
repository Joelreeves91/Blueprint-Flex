# Blueprint Flex

Open-ended running and strength app. One repo and one Netlify site serve everyone.

## Giving it to someone
Send them their own link:

    https://your-site.netlify.app/?u=george-bm-7k2q

The part after `?u=` is their code. Make it unguessable (name plus a few random characters), because the code is the only thing that identifies their plan. Letters, numbers and hyphens only.

They open the link, answer five questions, and the week builds itself. Their plan saves to the phone and to Firestore (collection `flex`, same Firebase project as Blueprint) under that code.

## What protects their data
- A pill at the top shows the state: Synced, Saving, Not saved to cloud, or This phone only.
- A phone with no code shows a banner and can link later with "Link with your code". If it already holds a plan and the cloud holds a different one, the person is asked which to keep. Nothing is written to the cloud until they choose.
- Nothing is pushed until the first cloud check has finished, and opening the app never stamps the phone's copy as newer. A phone that was away cannot overwrite progress made on another device.
- On iPhone the installed home-screen app has its own storage, separate from Safari. The app's start link carries the code, and if it ever opens empty, "Already have a code?" on the first screen restores everything.
- Progress, Back up or restore gives a spare backup code.

## Firestore rules
Allow read and write on `flex/{key}` the same way `plans/{id}` is allowed. If the pill says Not saved to cloud on a phone with a good connection, the rules are the first thing to check.

## One site per person (optional, still one repo)
Create extra Netlify sites from the same repo and set an environment variable `FLEX_KEY` on each (for example `george-bm-7k2q`). `inject.sh` bakes it into `index.html` at build, so that site syncs that person with no link needed. Sites with no `FLEX_KEY` work as the shared site. This only runs on repo-connected deploys; a drag-and-drop deploy skips the build step.

## How the week is built
Runs are placed first (long run Sunday, quality midweek, easy runs around them, strides on the run before the long run). Strength sessions are then placed by searching every assignment of sessions to days and keeping the cheapest: the same muscle group is never on consecutive days, lower-body sessions avoid the day before a hard run and the day after the long run, and the free day stays free unless every day is used. Paired sessions (Lower A and B, Push A and B, Pull A and B, Upper A and B) use different main lifts.

## After a redeploy
`sw.js` carries a cache name derived from the HTML, so phones pick up the new build on the next open.
