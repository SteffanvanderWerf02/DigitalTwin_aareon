import express from "express";
import sensor from "../controllers/measurements";
const router = express.Router();

// Add encoded sensor data to the database. Specifically made for adeunis sensors.
router.post("/addData", sensor.addData);

export = router;
