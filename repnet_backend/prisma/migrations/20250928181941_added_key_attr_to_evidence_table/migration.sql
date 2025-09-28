/*
  Warnings:

  - Added the required column `evidenceKey` to the `Evidence` table without a default value. This is not possible if the table is not empty.
  - Made the column `reportUrl` on table `report` required. This step will fail if there are existing NULL values in that column.

*/
-- AlterTable
ALTER TABLE `evidence` ADD COLUMN `evidenceKey` VARCHAR(191) NOT NULL;

-- AlterTable
ALTER TABLE `report` MODIFY `reportUrl` VARCHAR(191) NOT NULL;
