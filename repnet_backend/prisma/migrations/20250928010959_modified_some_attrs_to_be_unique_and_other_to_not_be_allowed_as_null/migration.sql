/*
  Warnings:

  - A unique constraint covering the columns `[impactName]` on the table `Impact` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[impactDescription]` on the table `Impact` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[siteDomain]` on the table `Site` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[tagName]` on the table `Tag` will be added. If there are existing duplicate values, this will fail.
  - Made the column `siteDomain` on table `site` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE `site` MODIFY `siteDomain` VARCHAR(191) NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX `Impact_impactName_key` ON `Impact`(`impactName`);

-- CreateIndex
CREATE UNIQUE INDEX `Impact_impactDescription_key` ON `Impact`(`impactDescription`);

-- CreateIndex
CREATE UNIQUE INDEX `Site_siteDomain_key` ON `Site`(`siteDomain`);

-- CreateIndex
CREATE UNIQUE INDEX `Tag_tagName_key` ON `Tag`(`tagName`);
