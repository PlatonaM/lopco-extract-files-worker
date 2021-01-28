#### Description

    {
        "name": "Extract Archive ",
        "image": "platonam/extract-files-worker:latest",
        "data_cache_path": "/data_cache",
        "description": "Extract archived files.",
        "configs": {
            "archive_extension": null
        },
        "input": {
            "type": "single",
            "fields": [
                {
                    "name": "input_archive",
                    "media_type": "application/octet-stream",
                    "is_file": true
                }
            ]
        },
        "output": {
            "type": "multiple",
            "fields": [
                {
                    "name": "output_file",
                    "media_type": "application/octet-stream",
                    "is_file": true
                }
            ]
        }
    }

Supported archive formats: tar, tar.gz, tar.bz2, tar.xz, tar.lz, tar.lzma, tar.lzo, tar.zst, zip
