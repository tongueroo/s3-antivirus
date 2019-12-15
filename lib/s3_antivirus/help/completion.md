## Examples

    s3-antivirus completion

Prints words for TAB auto-completion.

    s3-antivirus completion
    s3-antivirus completion hello
    s3-antivirus completion hello name

To enable, TAB auto-completion add the following to your profile:

    eval $(s3-antivirus completion_script)

Auto-completion example usage:

    s3-antivirus [TAB]
    s3-antivirus hello [TAB]
    s3-antivirus hello name [TAB]
    s3-antivirus hello name --[TAB]
