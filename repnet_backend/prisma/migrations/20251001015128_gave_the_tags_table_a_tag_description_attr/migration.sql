/*
  Warnings:

  - A unique constraint covering the columns `[tagDescription]` on the table `Tag` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `tagDescription` to the `Tag` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `tag` ADD COLUMN `tagDescription` VARCHAR(191) NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX `Tag_tagDescription_key` ON `Tag`(`tagDescription`);
