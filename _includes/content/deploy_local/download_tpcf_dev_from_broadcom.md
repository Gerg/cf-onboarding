
### What?
[Shepherd](https://github.gwd.broadcom.net/TNZ/shepherd) is a tool for accessing on-demand development environments, including [Open-Source Cloud Foundry](https://docs.cloudfoundry.org/concepts/overview.html) and proprietary [Tanzu Cloud Foundry](https://www.vmware.com/products/app-platform/tanzu) environments.

With Shepherd environments, you can get the Cloud Foundry developer experience (pushing apps, scaling, binding services, etc.) without first needing to learn how to deploy Cloud Foundry.

### How?

First, [install the shepherd CLI](https://github.gwd.broadcom.net/TNZ/shepherd2/blob/main/USERGUIDE.md#quick-start).

Next, log in to access the Shepherd pools:

```sh
$ shepherd config location https://v2-shepherd.lvn.broadcom.net
$ shepherd login user
```

Next, use the Shepherd CLI to claim a TPCF (also known as TAS) environment:

```sh
$ shepherd create lease --pool="tas-10_0-lite" --duration 24h
```

Claiming the environment will likely take some time, since most Shepherd environments are provisioned on-demand to limit costs. Feel free to read ahead while waiting for your environment to be available.

**Note:** The claimed environment will expire after 24 hours. You can extend your lease at any time by running:
```sh
$ shepherd update lease <lease-id> --extend-by <extension-time>
```

### Expected Result
You have a claimed CF environment in Shepherd.

### Resources
- [Tanzu Platform](https://www.vmware.com/products/app-platform/tanzu)

### Relevant Repos
- **Shepherd:** [TNZ/shepherd2](https://github.gwd.broadcom.net/TNZ/shepherd2)
- **TAS:** [TNZ/tas](https://github.gwd.broadcom.net/TNZ/tas)
