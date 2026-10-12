# Install the two assistants in Claude Desktop, running on your AWS account

Checked against the official documentation on **12 October 2026**. Each step links the page it comes from.

**Honest status:** this guide has **not** been run on a real AWS account. Connecting Claude Desktop to Amazon Bedrock sends real requests to the model, which are billed to the AWS account, so the AWS part is the first step of a real setup, done together. What *has* been verified is listed in [`verification/`](../verification/).

Setup has three parts: AWS (once), Claude Desktop on one computer, then the assistants.

---

## Part 1. AWS, once per account

1. **Sign in to the AWS console** with a user allowed to manage Amazon Bedrock and IAM.
   Source: [Deploy Claude Desktop on 3P with Amazon Bedrock](https://claude.com/docs/third-party/claude-desktop/bedrock), section "Set up AWS".

2. **Pick one AWS region** for Claude (for example `us-west-2`) and keep it for every step below. Model access, API keys and the app setting all work per region.
   Sources: same page ("Access is granted per region"); [Amazon Bedrock API keys](https://docs.aws.amazon.com/bedrock/latest/userguide/api-keys.html) ("A long-term key works only in the Region you generated it in").

3. **Turn on access to the Claude models.** Today, AWS enables most models by default, but for Anthropic models a first-time account must submit a short use-case form: in the [Amazon Bedrock console](https://console.aws.amazon.com/bedrock/), open the model catalog, select an Anthropic Claude model, and submit the use case details (a description of the use and a website URL). Access is usually granted right away; it can stay pending for a while, and AWS sends an email when it is ready. The account also needs a valid payment method for AWS Marketplace.
   Source: [Amazon Bedrock, Request access to models](https://docs.aws.amazon.com/bedrock/latest/userguide/model-access.html).
   Note: the Anthropic page still says "open **Model access** and request access"; the AWS page above is the more recent description of the same step.

4. **Choose how the app signs in to AWS.** Anthropic lists four ways. For one computer, the two that fit:
   - **Amazon Bedrock API key** (simplest, described as "Proof of concept, single team"). In the Bedrock console, left menu **API keys**, then generate a key. AWS recommends long-term keys "only for exploration"; short-term keys last up to 12 hours. The identity behind the key must be allowed `bedrock:CallWithBearerToken`.
   - **In-app AWS sign-in** through IAM Identity Center (recommended when several people will use it, since each person signs in with their own identity). Requires a permission set that allows `bedrock:InvokeModel` and `bedrock:InvokeModelWithResponseStream`.
   Sources: [Bedrock page, "Choose an authentication approach" and "Prepare devices"](https://claude.com/docs/third-party/claude-desktop/bedrock); [Amazon Bedrock API keys](https://docs.aws.amazon.com/bedrock/latest/userguide/api-keys.html).

5. **Note the model ID** you will use, as an inference-profile ID, for example `us.anthropic.claude-sonnet-5`. With an API key the app can discover the models by itself; with in-app sign-in the list is required.
   Source: [Bedrock page, "Configure the app"](https://claude.com/docs/third-party/claude-desktop/bedrock).
   Note: an inference profile can route requests to more than one region of its geography. Which profile to use, and what that means for where data is processed, is decided at setup. See [Cross-Region inference](https://docs.aws.amazon.com/bedrock/latest/userguide/cross-region-inference.html).

## Part 2. Claude Desktop on one computer

Anthropic documents a single-machine setup for organizations without device management (MDM).
Source: [Installation and setup, "Single-machine setup"](https://claude.com/docs/third-party/claude-desktop/installation).

6. **Check the computer.** Cowork needs macOS 14 (Sonoma) or later, or Windows 10 build 19041 or later with the `.msix` installer. Anthropic offers a small [readiness check](https://claude.com/docs/third-party/claude-desktop/installation#check-device-readiness) that reports "This computer is ready for Cowork".

7. **Install Claude Desktop** from [claude.com/download](https://claude.com/download).

8. **Open the app without signing in.** Anthropic's wording: "Do not sign in or create an Anthropic account." From the macOS menu bar choose **Help > Troubleshooting > Enable Developer Mode**, then **Developer > Configure Third-Party Inference...**

9. **Fill in the Connection section.** Set **Inference provider** to **Bedrock**, then in the **Bedrock credentials** card:
   - **AWS region**: the region from step 2.
   - With an API key: paste it in **AWS bearer token**.
   - With in-app AWS sign-in: fill **AWS SSO start URL**, **AWS SSO region**, **AWS SSO account ID**, **AWS SSO role name** (all four are required).
   - Under **Models**, add the model ID from step 5.
   Source: [Bedrock page, "Configure the app"](https://claude.com/docs/third-party/claude-desktop/bedrock).

10. **Click Apply Changes, then Save & Restart.** The sign-in screen now offers to start Claude Desktop with this configuration.
    Source: [Installation and setup, step 4](https://claude.com/docs/third-party/claude-desktop/installation).

11. **Test the connection** (button in the same window). This sends a short real request to the model, so it is the first billed call.
    Source: [Bedrock page, "Connection probe"](https://claude.com/docs/third-party/claude-desktop/bedrock).
    If something is off: **Help > Troubleshooting > Generate Diagnostic Report**, then **Export to file**; `provider-status.txt` says whether the provider settings are complete.

## Part 3. Add the two assistants

12. **Download the plugin**: [`dist/korotkina-coworkers-plugin.zip`](../dist/korotkina-coworkers-plugin.zip). It contains both assistants.

13. **Upload it** from the app's Plugins page. Anthropic documents the path as **Customize > Plugins > Add > Upload plugin** (written for claude.ai; the Bedrock page says users install plugins "from the Plugins settings page"). Users of Claude Desktop on Bedrock may add their own plugins and skills unless an administrator turned that off.
    Sources: [Plugin structure and testing, "Test the plugin on each surface"](https://claude.com/docs/plugins/build); [MCP, plugins, skills, and hooks, "User extensions"](https://claude.com/docs/third-party/claude-desktop/extensions).
    To add a single assistant instead, upload its skill ZIP under **Customize > Skills** and turn it on ([Create custom skills](https://claude.com/docs/skills/how-to)).

14. **Try it.** Paste a client's message and ask: "A client wrote to the showroom. Draft the response." Claude picks the matching assistant and returns a draft reply and a note. Nothing is sent anywhere by the assistant.

## What this does not cover yet

- Sharing between several people: Claude Desktop keeps chats, skills and plugins on each computer; there is no in-app sharing between users. An administrator can distribute plugins instead ([feature matrix](https://claude.com/docs/third-party/claude-desktop/feature-matrix)).
- Work that runs unattended: sessions run on the computer, which must stay awake for long tasks (same page).
- Connecting the assistants to an inbox or to the booking system. That is a later step, once the first workflow is chosen.
