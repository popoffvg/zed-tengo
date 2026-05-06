use zed_extension_api as zed;

struct TengoExtension {
    cached_binary_path: Option<String>,
}

impl zed::Extension for TengoExtension {
    fn new() -> Self {
        Self {
            cached_binary_path: None,
        }
    }

    fn language_server_command(
        &mut self,
        language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> zed::Result<zed::Command> {
        if let Some(path) = worktree.which("tengo-lsp") {
            return Ok(zed::Command {
                command: path,
                args: vec![],
                env: vec![],
            });
        }

        let binary_path = self.ensure_installed(language_server_id)?;
        Ok(zed::Command {
            command: binary_path,
            args: vec![],
            env: vec![],
        })
    }
}

impl TengoExtension {
    fn ensure_installed(&mut self, id: &zed::LanguageServerId) -> zed::Result<String> {
        if let Some(path) = &self.cached_binary_path {
            return Ok(path.clone());
        }

        zed::set_language_server_installation_status(
            id,
            &zed::LanguageServerInstallationStatus::Downloading,
        );

        let release = zed::latest_github_release(
            "popoffvg/tengo-lsp",
            zed::GithubReleaseOptions {
                require_assets: true,
                pre_release: false,
            },
        )?;

        let (platform, arch) = zed::current_platform();
        let asset_name = format!(
            "tengo-lsp-{}-{}.tar.gz",
            match platform {
                zed::Os::Mac => "darwin",
                zed::Os::Linux => "linux",
                zed::Os::Windows => "windows",
            },
            match arch {
                zed::Architecture::Aarch64 => "aarch64",
                zed::Architecture::X8664 => "x86_64",
                _ => return Err("unsupported architecture".into()),
            },
        );

        let asset = release
            .assets
            .iter()
            .find(|a| a.name == asset_name)
            .ok_or_else(|| format!("no release asset matching {asset_name}"))?;

        let dir = format!("tengo-lsp-{}", release.version);
        let binary = format!("{dir}/tengo-lsp");

        zed::download_file(
            &asset.download_url,
            &dir,
            zed::DownloadedFileType::GzipTar,
        )?;
        zed::make_file_executable(&binary)?;

        self.cached_binary_path = Some(binary.clone());
        Ok(binary)
    }
}

zed::register_extension!(TengoExtension);
