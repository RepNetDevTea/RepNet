/*
  Warnings:

  - Added the required column `impactScore` to the `Impact` table without a default value. This is not possible if the table is not empty.
  - Added the required column `tagScore` to the `Tag` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `impact` ADD COLUMN `impactScore` INTEGER NOT NULL;

-- AlterTable
ALTER TABLE `tag` ADD COLUMN `tagScore` INTEGER NOT NULL;
