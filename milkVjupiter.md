# Milk-V Jupiter

Here I will (if it's worth it) keep track of my projects I've done with the Milk-V Jupiter.

## OpenSUSE Tumbleweed with ATI Radeon R9 290

Project OpenSUSE with an external ATI Radeon R9 290

- [project](milkVjupiter/OpenSUSEATIRadeonR9_290.md)

## AMDGPU Working

Used with the U-Boot 2022.10spacemit (Jun 06 2024 - 09:32:38 +0800) on flash (what was already on it when I received it).

| kernel | Videocard | Working? | Working With Express Riser Card? |
|---|---|---|---|
| [6.1](https://github.com/Opvolger/spacemit-k1-linux-6.1/tree/bl-v1.0.y-amdgpu) | ATI Radeon HD 5450 (Cedar PRO) | Yes | Not tested yet |
| [6.1](https://github.com/Opvolger/spacemit-k1-linux-6.1/tree/bl-v1.0.y-amdgpu) | ATI Radeon HD 5850 (Cypress PRO) | Yes | Not tested yet |
| [6.1](https://github.com/Opvolger/spacemit-k1-linux-6.1/tree/bl-v1.0.y-amdgpu) | AMD Radeon R9 290 (Hawaii PRO) | No, fans 100% at U-Boot, no device detected with lspci | Yes |
| [6.1](https://github.com/Opvolger/spacemit-k1-linux-6.1/tree/bl-v1.0.y-amdgpu) | AMD Radeon R9 290X (Hawaii XT) | No, fans 100% at U-Boot, no device detected with lspci | Not tested yet |
| [6.1](https://github.com/Opvolger/spacemit-k1-linux-6.1/tree/bl-v1.0.y-amdgpu) | AMD Radeon RX 6600 (Navi 23 XL) | Kernel panic after init. AMD card | Not tested yet |
