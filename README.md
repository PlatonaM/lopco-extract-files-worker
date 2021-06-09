## lopco-extract-files-worker

Extract archived files as dynamic or named outputs.

### Configuration

`archive_extension`: Archive file extension. Supported formats: `tar`, `tar.gz`, `tar.bz2`, `tar.xz`, `tar.lz`, `tar.lzma`, `tar.lzo`, `tar.zst` and `zip`

`named_outputs`: List of file names included in the archive.

### Inputs

Type: single

`input_archive`: Archive file.

### Outputs

Type: multiple

`output_file`: Extracted file.

Type: single

_User defined output names matching the file names provided in the `named_outputs` config option._

### Description

    {
        "name": "Extract Archive ",
        "image": "platonam/lopco-extract-files-worker:latest",
        "data_cache_path": "/data_cache",
        "description": "Extract archived files.",
        "configs": {
            "archive_extension": null,
            "named_outputs": null
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

    Alternative with named outputs:

    {
        "name": "Extract Archive ",
        "image": "platonam/lopco-extract-files-worker:latest",
        "data_cache_path": "/data_cache",
        "description": "Extract archived files.",
        "configs": {
            "archive_extension": null,
            "named_outputs": "output_a;output_b"
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
            "type": "single",
            "fields": [
                {
                    "name": "output_a",
                    "media_type": "text/csv",
                    "is_file": true
                },
                {
                    "name": "output_b",
                    "media_type": "text/csv",
                    "is_file": true
                }
            ]
        }
    }
