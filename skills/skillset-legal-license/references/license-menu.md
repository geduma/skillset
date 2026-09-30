# License menu

Show this table to the user (summarized, in whatever language they're speaking) before choosing. Never assume a default — the user always decides, case by case.

| # | License | Best for | What it allows | What it requires |
|---|---------|----------|-----------------|-------------------|
| 1 | **AGPL-3.0** | Services, APIs, proxies, apps that run on a server/SaaS | Free use, modification, and self-hosting | If someone offers a modified version **as a network service**, they must publish that modified source code. Closes the "SaaS loophole" that plain GPL doesn't cover. |
| 2 | **GPL-3.0** | Libraries, CLIs, desktop apps distributed as a binary/package (not as a network service) | Free use, modification, and distribution | Anyone distributing the software or a modification must publish the source code. Doesn't cover "I use it as a service without distributing it". |
| 3 | **LGPL-3.0** | Libraries you want projects under a different license to be able to link/use without inheriting full copyleft | Use in proprietary projects if only linked (not modified) | Modifications to the library itself must be published. |
| 4 | **MPL-2.0** | Libraries/modules where you want copyleft only at the file level, allowing them to mix with proprietary code | Combine with closed-source code in the same project | Individual MPL-covered files that get modified must be published. |
| 5 | **Apache-2.0** | Projects prioritizing wide adoption and patent protection, without requiring forks to stay open | Commercial use, closing the source, no obligation to publish changes | Preserve copyright and license notices; includes an explicit patent grant. |
| 6 | **MIT** | Small projects/utilities where you only want attribution, no copyleft restrictions | Nearly anything, including closing the source | Preserve the copyright and license notice. |
| 7 | **BSD-3-Clause** | Similar to MIT, with an extra clause preventing use of the author's name to promote derivatives | Same as MIT | Preserve the notice; don't use the author's/contributors' name for promotion without permission. |
| 8 | **Other / closed source / "all rights reserved"** | The user doesn't want the code to be open source at all, just publicly readable | Nothing, except what the user explicitly authorizes | Requires drafting a copyright notice with no usage license — confirm the exact wording with the user; don't use an open-source license template for this. |

## Quick decision guide to present to the user

Ask first: **"Does this project run as a network service (API, backend, proxy, SaaS), or is it distributed as a library/package/CLI?"**

- If it's a **network service** and the user wants to prevent others from profiting by offering it as SaaS without giving anything back → suggest **AGPL-3.0** as the primary option, but let the user confirm.
- If it's a **library meant for others to integrate** into their own projects (including proprietary ones) → suggest **MIT or Apache-2.0** if the goal is wide adoption, or **LGPL-3.0/MPL-2.0** if they want some copyleft without scaring off integrators.
- If it's an **app/CLI distributed as a binary or package** → suggest **GPL-3.0** for strong copyleft, or **MIT/Apache-2.0** if adoption is the priority.
- If the user explicitly says they **don't want anyone profiting from their work under any circumstances**, even distributing it modified without offering it as a service → explain that no standard OSI license prevents commercial use per se (that would no longer be "open source" in the strict sense), and mention non-standard "source-available" licenses (e.g. PolyForm Noncommercial, Business Source License) as an alternative — but clarify: these aren't in `assets/licenses/`, so if the user wants one, look up the official text on the web first (never invent or paraphrase it from memory).

Always end the selection with an explicit confirmation before writing the LICENSE file.
