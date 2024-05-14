import { Router, Request, Response } from "express";
import {
  getLongestBreakNoPLSQL,
  getLongestStreakNoPLSQL,
  getLongestBreakPLSQL,
  getLongestStreakPLSQL,
} from "../handlers/insights";

const insightsRouter = Router();

insightsRouter.get(
  "/find-longest-streak",
  async (req: Request, res: Response) => {
    try {
      const result = await getLongestStreakPLSQL();
      res.status(200).json(result);
    } catch (error) {
      console.log(error);
      res.status(500).json({ message: "Internal server error" });
    }
  }
);

insightsRouter.get(
  "/find-longest-streak-no-plsql",
  async (req: Request, res: Response) => {
    try {
      const result = await getLongestStreakNoPLSQL(43957994);
      res.status(200).json(result);
    } catch (error) {
      console.log(error);
      res.status(500).json({ message: "Internal server error" });
    }
  }
);

insightsRouter.get(
  "/find-longest-break",
  async (req: Request, res: Response) => {
    try {
      const result = await getLongestBreakPLSQL();
      res.status(200).json(result);
    } catch (error) {
      console.log(error);
      res.status(500).json({ message: "Internal server error" });
    }
  }
);

insightsRouter.get(
  "/find-longest-break-no-plsql",
  async (req: Request, res: Response) => {
    try {
      const result = await getLongestBreakNoPLSQL(43957994);
      res.status(200).json(result);
    } catch (error) {
      console.log(error);
      res.status(500).json({ message: "Internal server error" });
    }
  }
);

export default insightsRouter;
