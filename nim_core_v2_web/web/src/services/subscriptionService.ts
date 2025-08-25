import { successRes, failRes, emit } from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM from 'nim-web-sdk-ng'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'
import { V2NIMCustomUserStatusParams, V2NIMCustomUserStatusPublishResult, V2NIMSubscribeUserStatusOption, V2NIMUnsubscribeUserStatusOption, V2NIMUserStatus, V2NIMUserStatusSubscribeResult } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMSubscriptionService'

const TAG_NAME = 'SubscriptionService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)
class SubscriptionService {
  constructor(private rootService: RootService, private nim: V2NIM) {
    this._onUserStatusChanged = this._onUserStatusChanged.bind(this)
    nim.V2NIMSubscriptionService.on('onUserStatusChanged', this._onUserStatusChanged)
  }

  destroy(): void {
    //
    this.nim.V2NIMSubscriptionService.off('onUserStatusChanged', this._onUserStatusChanged)
  }

  @loggerDec
  async subscribeUserStatus(params:{option: V2NIMSubscribeUserStatusOption}): Promise<NIMResult<{accountIds:string[]}>> {
    try {
      return successRes({
        accountIds:await this.nim.V2NIMSubscriptionService.subscribeUserStatus(params.option)
    })
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async unsubscribeUserStatus(params:{option:V2NIMUnsubscribeUserStatusOption}): Promise<NIMResult<{accountIds:string[]}>> {
    try {
      return successRes({
        accountIds:await this.nim.V2NIMSubscriptionService.unsubscribeUserStatus(params.option)
      }
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async publishCustomUserStatus(params:{params: V2NIMCustomUserStatusParams}): Promise<NIMResult<V2NIMCustomUserStatusPublishResult>> {
    try {
      return successRes(
        await this.nim.V2NIMSubscriptionService.publishCustomUserStatus(params.params)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async queryUserStatusSubscriptions(params:{accountIds:string[]}): Promise<NIMResult<{subscribeResultList: V2NIMUserStatusSubscribeResult[]}>> {
    try {
      return successRes({
        subscribeResultList: await this.nim.V2NIMSubscriptionService.queryUserStatusSubscriptions(params.accountIds)
      }
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  private _onUserStatusChanged(users: V2NIMUserStatus[]): void {
    logger.log('_onUserStatusChanged', users)
    emit('SubscriptionService', 'onUserStatusChanged', { userStatusList: users })
  }
}

export default SubscriptionService
