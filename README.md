# Blueprint Flex

Open-ended running and strength app. One repo and one Netlify site serve everyone.

## Giving it to someone
Either send them the bare site: after the five questions the app creates a code for them (like `k7m2-x9pq`), shows it with their link, and saves to the cloud under it. Or make the code yourself and send a link:

    https://your-site.netlify.app/?u=george-bm-7k2q

The part after `?u=` is their code. Make it unguessable (name plus a few random characters), because the code is the only thing that identifies their plan. Letters, numbers and hyphens only.

They open the link, answer five questions, and the week builds itself. Their plan saves to the phone and to Firestore (collection `flex`, same Firebase project as Blueprint) under that code.

## What protects their data
- A pill at the top shows the state: Synced, Saving, Not saved to cloud, or This phone only.
- A phone with no code shows a banner and can link later with "Link with your code". If it already holds a plan and the cloud holds a different one, the person is asked which to keep. Nothing is written to the cloud until they choose.
- Nothing is pushed until the first cloud check has finished, and opening the app never stamps the phone's copy as newer. A phone that was away cannot overwrite progress made on another device.
- On iPhone the installed home-screen app has its own storage, separate from Safari. The app's start link carries the code, and if it ever opens empty, "Already have a code?" on the first screen restores everything.
- Progress, Back up or restore gives a spare backup code.

## Firestore rules (do this once before anyone uses it)
The app writes to a new collection, `flex`, in the same Firebase project as Blueprint. Until the rules allow it, every save is refused and the app shows "The cloud refused the request". In the Firebase console, open the `runner-plan-host` project, Firestore Database, Rules, and add a `flex` block beside the existing `plans` one:

    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {
        match /plans/{planId} {
          allow read, write: if true;
        }
        match /flex/{key} {
          allow read, write: if true;
        }
      }
    }

Publish, then reload the app. Codes are the only protection, so keep them unguessable (the app's generated codes are).

## One site per person (optional, still one repo)
Create extra Netlify sites from the same repo and set an environment variable `FLEX_KEY` on each (for example `george-bm-7k2q`). `inject.sh` bakes it into `index.html` at build, so that site syncs that person with no link needed. Sites with no `FLEX_KEY` work as the shared site. This only runs on repo-connected deploys; a drag-and-drop deploy skips the build step.

## Exercise selection
Chosen on the strength-coach skill's rules: tension through a full range with attention to the lengthened position, high stimulus-to-fatigue ratio, loadability, joint cost, and never surface-EMG "activation" rankings. For runners the lower body is built around heavy bilateral lifts at 4 to 6 reps (near-maximal loads are what improve running economy in the 2022 and 2024 meta-analyses), a small dose of plyometrics done fresh, Nordic hamstring curls, loadable hip abduction, Copenhagen planks and bent-knee calf work. Rows default to chest-supported, machine and cable versions; trunk work is loaded (cable chop, landmine rotation, suitcase carry, ab rollout) with the Pallof press kept only as a regression. Every slot has pattern-matched alternatives for the person's equipment, and calf or Achilles issues remove plyometrics.

## Training rules (from the running-coach and strength-coach skills)
- One quality run a week by default. A second is a setting that unlocks when earned: four or more run days, eight finished weeks, about five hours of running a week, no week marked too much in the last four, not a beginner, under 50. It sits 48 hours from the other hard runs and drops to easy plus strides in weeks with a structured long run, so there are never three hard runs in a week.
- Every quality session answers smooth, hard but fine or struggled. Struggled never levels up; three in a row forces a lighter week and pauses the second slot.
- Main sets are capped by weekly volume: threshold about 10 percent, intervals 8 percent (10 km max), fast reps 5 percent (5 km max), with floors so the core sessions always fit at starter volume. Held rungs say so.
- The running goal weights the session mix and the long runs: 5K and 10K lean on intervals, half on threshold with progressive and fast-finish long runs, marathon on marathon-pace blocks (16, 20, 30, 40 minutes) and no intervals. Structured long runs need a 60 minute long run, never come two in a row and never on a lighter week.
- Heart rate: easy and long runs are controlled by heart rate when a monitor is set up, pace as a guide. Watch zones (the entered top of the easy zone) or max and resting on heart rate reserve with Garmin's bands. Garmin and other watches get five numbered zones; COROS gets its six named zones on its own breakpoints (easy cap at 74 percent of reserve). COROS users are warned that the app's waking resting figure reads high and told to count a true resting pulse or use watch zones. Estimated max is refused.
- Over 50: 72 hours between hard runs, three build weeks at most, no second quality slot.

## How the week is built
Runs are placed first (long run Sunday, quality midweek, easy runs around them, strides on the run before the long run). Strength sessions are then placed by searching every assignment of sessions to days and keeping the cheapest: the same muscle group is never on consecutive days, heavy legs the day before a hard run is a last resort (the search will swap a full-body or lower session for an upper or hips-and-core one first, keeping at least one lower session), lifting after a hard run on the same day is preferred to lifting the day before, and the free day stays free unless every day is used. Paired sessions (Lower A and B, Push A and B, Pull A and B, Upper A and B) use different main lifts.

## After a redeploy
`sw.js` carries a cache name derived from the HTML, so phones pick up the new build on the next open.
