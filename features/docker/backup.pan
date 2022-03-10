unique template features/docker/backup;

variable DOCKER_BACKUP_DIR ?= "/backup";

variable DOCKER_BACKUP_MAIL_OK =    if ( is_defined(DOCKER_BACKUP_MAIL_OK) ) {
                                        format("-mailok %s", SELF);
                                    } else {
                                        "";
                                    };

variable DOCKER_BACKUP_MAIL_ERR =   if ( is_defined(DOCKER_BACKUP_MAIL_ERR) ) {
                                        format("-mailerr %s", SELF);
                                    } else {
                                        "";
                                    };

variable DOCKER_BACKUP_COMMAND ?= format("/usr/sbin/backup_docker_data -dir %s %s %s",
                                        DOCKER_BACKUP_DIR,
                                        DOCKER_BACKUP_MAIL_OK,
                                        DOCKER_BACKUP_MAIL_ERR
                                        );

variable DOCKER_BACKUP_FREQUENCY ?= "30 11 * * *";

variable DOCKER_BACKUP_SCRIPT ?= 'features/docker/backup_docker_data';

include 'components/filecopy/config';
'/software/components/filecopy/services/{/usr/sbin/backup_docker_data}' = dict(
                            "config", file_contents(DOCKER_BACKUP_SCRIPT),
                            "owner", "root",
                            "perms", "0755",
                            );

include 'components/cron/config';
"/software/components/cron/entries" = {
    SELF[length(SELF)] = dict("name", "backup_docker_data",
                            "frequency", DOCKER_BACKUP_FREQUENCY,
                            "command", DOCKER_BACKUP_COMMAND,
                            );
    SELF;
};

