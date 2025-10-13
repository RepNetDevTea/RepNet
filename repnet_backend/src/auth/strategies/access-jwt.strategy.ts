import { Inject, Injectable } from "@nestjs/common";
import { PassportStrategy } from "@nestjs/passport";
import { ExtractJwt, Strategy } from "passport-jwt";
import accessJwtConfig from "../config/access-jwt.config";
import type { ConfigType } from "@nestjs/config";

@Injectable()
export class AccessJwtAuthStrategy extends PassportStrategy(Strategy) {
  constructor(
    @Inject(accessJwtConfig.KEY) 
    private readonly accessJwtConfiguration: ConfigType<typeof accessJwtConfig>
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: accessJwtConfiguration.secret!,
    });
  }

  validate(payload: object) {
    return payload;
  }
}