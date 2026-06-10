# SEIR-1 — WEEK 7 NOTES
## GCP Static Website Hosting with Terraform
**Program:** Systems Engineering & Identity Responsibility
**Lab:** Deploy a public static website on Google Cloud Storage, fully provisioned with Terraform

---

## What is it?

Week 7 was a hands-on lab to deploy a real, publicly accessible static website using a Google Cloud Storage (GCS) bucket — with everything provisioned through Terraform.

The lab ties together several skills from earlier weeks: writing Terraform code (`provider.tf`, `backend.tf`, `main.tf`), running the IVPAD sequence (init / validate / plan / apply / destroy), and working with GCP resources. What's new this week is using Terraform to manage **objects** inside a bucket (not just the bucket itself), making a bucket **publicly accessible** with an IAM policy, and configuring **static website hosting** settings.

The end result: a working public URL that anyone on the internet can visit to see an HTML page with custom styling and an image — all built and deployed without ever touching the GCP console for resource creation.

---

## Key Services & Terms

**Google Cloud Storage (GCS)**
GCP's object storage service. Equivalent to AWS S3. Stores files (objects) in containers called buckets. Each bucket has a globally unique name across all of GCP.

**Bucket**
The top-level container for objects in GCS. Created with the `google_storage_bucket` Terraform resource. Has properties like name, location, force_destroy, and access mode.

**Object**
An individual file stored inside a bucket (HTML, CSS, image, etc.). Created with the `google_storage_bucket_object` Terraform resource. Each object has a name, source (file on disk), bucket reference, and content_type.

**Content-Type (MIME type)**
A header that tells browsers how to render a file. Critical to set correctly per object:
- HTML → `text/html`
- CSS → `text/css`
- JPEG → `image/jpeg`
- PNG → `image/png`

**Uniform Bucket-Level Access**
A bucket setting that disables legacy per-object ACLs and forces all permissions through IAM only. Modern, recommended approach. Required for clean public-access patterns.

**`force_destroy = true`**
A bucket setting that allows `terraform destroy` to delete a bucket even when it contains objects. Without this, GCS refuses to delete a non-empty bucket.

**`google_storage_bucket_iam_member`**
Terraform resource that grants ONE member ONE role on a bucket. Additive only — does not affect other permissions. The safe choice (vs. `iam_policy` which replaces everything, and `iam_binding` which replaces all members of a role).

**`allUsers`**
A special GCP identifier meaning "anyone on the internet, no authentication." Used as the member when making a bucket publicly readable.

**`roles/storage.objectViewer`**
Predefined GCP role granting read access to objects in a bucket. Least privilege for public access — visitors can read but not write or delete.

**Static Website Hosting**
A bucket setting that tells GCS to serve `index.html` as the default page and `404.html` (or other) as the error page. Configured with the `website {}` block on the bucket resource.

**Interpolation (`${...}`)**
HCL syntax that injects the value of one resource's attribute into a string at apply time. Lets the output URL reference the actual bucket name without hardcoding it.

**Infrastructure as Code (IaC)**
The broader concept Terraform implements: defining infrastructure in code files that are version-controlled, reviewable, repeatable, and shareable.

---

## How it Works

The lab built up in stages, applying Terraform after each stage to test before adding the next piece.

**Stage 1 — Setup**
Created a working folder at `/Users/devopsstudy/Class_7_ZION/Class 7.5/SEIR-1/weekly_lessons/week7/terraform`, downloaded the lab assets via `curl`, and added a personal image (converted from PNG to JPEG with `sips` because `index.html` expected `image.jpg`).

**Stage 2 — Provider, backend, and bucket**
Wrote `provider.tf` (configures the Google provider, points at project `kamau-lab4-2026`, region `us-central1`).
Wrote `backend.tf` (local state — fine for a POC lab; remote GCS backend would be the production choice).
Wrote `main.tf` with just the bucket resource — name, location, `force_destroy`, and `uniform_bucket_level_access`.
Ran `terraform init`, `validate`, `plan`, `apply` to deploy the empty bucket.

**Stage 3 — Upload objects one at a time**
Added 4 `google_storage_bucket_object` resources to `main.tf` — one for each file: `index.html`, `404.html`, `style.css`, `image.jpg`. Each with the correct `content_type`. Applied between each one to verify in the bucket.

**Stage 4 — Make the bucket public**
Added `google_storage_bucket_iam_member` granting `allUsers` the `roles/storage.objectViewer` role on the bucket. After apply, the bucket and objects became readable by anyone on the internet.

**Stage 5 — Static website hosting**
Added a `website {}` block to the bucket resource with `main_page_suffix = "index.html"` and `not_found_page = "404.html"`. This tells GCS to serve those pages as the default and error pages.

**Stage 6 — Output**
Created `outputs.tf` that constructs the public URL using string interpolation:
```
"https://storage.googleapis.com/${google_storage_bucket.site.name}/index.html"
```
After apply, Terraform prints the live URL automatically.

**Final result:** A public URL serving a styled HTML page with a custom image, hosted entirely on GCS, deployed and managed through Terraform.

---

## Things to Remember

- **Build in stages, apply between each one.** Avoid writing 6 resources at once — debugging one failure at a time is much easier than debugging six.
- **Bucket names are globally unique** across all of GCP. Same rule as S3.
- **`force_destroy = true` is required** to let `terraform destroy` clean up a bucket with files in it. The lab specifically calls this out.
- **Always set `content_type` on objects.** Browsers refuse to apply CSS that arrives as `text/plain`, and may not render images correctly without the right MIME type.
- **Convert files properly — don't just rename extensions.** A renamed `.png → .jpg` still has PNG bytes inside. Use `sips -s format jpeg input.png --out output.jpg` to do a real conversion.
- **`google_storage_bucket_iam_member` is the safe IAM choice** — additive only. The `iam_policy` resource is dangerous because it replaces everything.
- **HCL block structure is strict.** Every `{` needs a matching `}` on its own line. Nested blocks need nested closes:
  ```
  resource "outer" {
    inner {
    }
  }
  ```
- **Two GCP auth commands are required:**
  - `gcloud auth login` for the `gcloud` CLI itself
  - `gcloud auth application-default login` for Terraform (separate credential store)
- **Folder hygiene matters.** Multiple folders with similar names (`weekg`, `Week 7`, `week_7`, `week7`) caused real confusion this lab. Pick one naming convention and stick with it.
- **GCP does not give a special static-site URL** like AWS S3 does. The URL must be constructed manually using `https://storage.googleapis.com/BUCKET/index.html`.
- **Terraform tracks every object as a resource in state.** Fine for a 4-file lab, problematic for sites with thousands of files — that's why content deployment usually belongs to `gsutil rsync` or CI/CD, not Terraform.

---

## Questions I Have

- For a real production static site, what's the cleanest way to combine a Cloud Load Balancer + Cloud CDN + custom domain in front of a GCS bucket? Is there a standard Terraform module for this?
- When using `gsutil rsync` for content updates, how do I prevent it from conflicting with Terraform's state for the objects I originally uploaded via Terraform?
- Are there any cases where `iam_binding` (authoritative for one role) is actually preferable to `iam_member` (additive)?
- How does `uniform_bucket_level_access` interact with signed URLs for time-limited file access?
- If I put the state file in a remote GCS backend, does that bucket itself need to be Terraformed too — and if so, how do I bootstrap the chicken-and-egg problem?

---

## Real-World Analogy

A GCS bucket configured for static website hosting is like **renting a public storage unit in a strip mall and turning it into a shop window.**

- The **bucket** is the storage unit itself — you rent the space, give it a unique address, and set the rules for who can come in.
- The **objects** are the items you put on the shelves — each one labeled (named) and tagged (content_type) so anyone walking by knows what it is.
- **`uniform_bucket_level_access`** is the choice to use one modern security system (cards and codes) instead of mixing it with old physical keys. Less confusing, fewer mistakes.
- **`iam_member` granting `allUsers` the `objectViewer` role** is unlocking the door and putting up a "Browsing Welcome — Look But Don't Touch" sign. Anyone can walk in and see; nobody can take or change anything.
- **The `website {}` block** is the storefront sign — telling visitors which item on the shelf is the "front display" (`index.html`) and which one to point them to if they're looking for something that doesn't exist (`404.html`).
- **Terraform itself** is the contract and the keys. Lose the keys (the state file) and you can't easily change the unit anymore — even though everything in it still exists.

The whole thing works because every part is documented, repeatable, and has a clear single owner. Anyone on the team with the contract can rebuild the same unit somewhere else, identical, in minutes.

---

## Lab Follow-Up Answers

**1. Is Terraform a good tool to provision buckets?**
Yes. Terraform makes it easier than the console because it enables version tracking, repeatable deployments, and easy scaling — making 4 buckets or 40 buckets is the same effort once the code exists. The code itself acts as documentation, so over time anyone can see exactly what was built and why. This is the broader concept of Infrastructure as Code (IaC).

**2. Is Terraform an ideal tool to upload objects into buckets? Why or why not?**
Terraform can upload objects, but it is not ideal for that job. Every uploaded file becomes a tracked resource in the state file, so a site with thousands of files would create a huge state file and slow down every plan and apply. A better approach is to use Terraform for the infrastructure (the bucket, IAM, website settings) and a tool like `gsutil rsync` or a CI/CD pipeline for the actual file uploads.

**3. Explain how you wrote the output.**
In AWS, you get a special static website endpoint URL automatically. GCP does not, so I had to build the URL myself by combining the standard GCS URL prefix with the bucket name and `/index.html`. Instead of hardcoding the bucket name, I used Terraform interpolation with `${google_storage_bucket.site.name}`, which is a reference to the bucket resource's name attribute. This way, if the bucket name ever changes, the output updates automatically without me having to edit it.

**4. IAM and access:**
*(To be completed — uniform bucket-level access and the IAM resource explained.)*

**5. What setting enabled static website hosting?**
*(To be completed — the `website {}` block with `main_page_suffix` and `not_found_page`.)*

**6. What changes could improve this infrastructure?**
*(To be completed — Cloud Load Balancer + Cloud CDN, custom domain with HTTPS, remote GCS backend for state, gsutil rsync for content updates, lifecycle rules, etc.)*

---

## Program Mantras — Week 7 Additions

- "Build in stages, apply between each one."
- "Terraform manages infrastructure. Other tools manage content."
- "Globally unique means globally unique. Add entropy if needed."
- "Set content_type on every object. Browsers do not guess kindly."
- "iam_member is additive. iam_policy is destructive. Choose wisely."
- "Folder confusion costs more time than the lab itself."

---

**END OF WEEK 7 NOTES**
