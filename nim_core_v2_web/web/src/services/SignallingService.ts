import { successRes, failRes, emit } from '../utils'
import { NIMResult } from '../types'
import RootService from './rootService'
import { logger } from '../logger'
import { createLoggerDecorator } from '@xkit-yx/utils'
import V2NIM from 'nim-web-sdk-ng'
import { V2NIMError } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/types'
import { V2NIMSignallingAcceptInviteParams, V2NIMSignallingCallParams, V2NIMSignallingCallResult, V2NIMSignallingCallSetupParams, V2NIMSignallingCallSetupResult, V2NIMSignallingCancelInviteParams, V2NIMSignallingChannelInfo, V2NIMSignallingChannelType, V2NIMSignallingEvent, V2NIMSignallingInviteParams, V2NIMSignallingJoinParams, V2NIMSignallingRejectInviteParams, V2NIMSignallingRoomInfo } from 'nim-web-sdk-ng/dist/v2/NIM_BROWSER_SDK/V2NIMSignallingService'

const TAG_NAME = 'SignallingService'
const loggerDec = createLoggerDecorator(TAG_NAME, logger)

class SignallingService {
  constructor(private rootService: RootService, private nim: V2NIM) {
    this._onOnlineEvent = this._onOnlineEvent.bind(this)
    this._onOfflineEvent = this._onOfflineEvent.bind(this) 
    this._onMultiClientEvent = this._onMultiClientEvent.bind(this)
    this._onSyncRoomInfoList = this._onSyncRoomInfoList.bind(this)
    nim.V2NIMSignallingService.on('onOnlineEvent', this._onOnlineEvent)
    nim.V2NIMSignallingService.on('onOfflineEvent', this._onOfflineEvent)
    nim.V2NIMSignallingService.on('onMultiClientEvent', this._onMultiClientEvent)
    nim.V2NIMSignallingService.on('onSyncRoomInfoList', this._onSyncRoomInfoList)
  }

  destroy(): void {
    //
    this.nim.V2NIMSignallingService.off('onOnlineEvent', this._onOnlineEvent)
    this.nim.V2NIMSignallingService.off('onOfflineEvent', this._onOfflineEvent)
    this.nim.V2NIMSignallingService.off('onMultiClientEvent', this._onMultiClientEvent)
    this.nim.V2NIMSignallingService.off('onSyncRoomInfoList', this._onSyncRoomInfoList)
  }

  @loggerDec
  async call(params:{params: V2NIMSignallingCallParams}): Promise<NIMResult<V2NIMSignallingCallResult>> {
    try {
      return successRes(
        await this.nim.V2NIMSignallingService.call(params.params)
    )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async callSetup(params:{params:V2NIMSignallingCallSetupParams}): Promise<NIMResult<V2NIMSignallingCallSetupResult>> {
    try {
      return successRes(await this.nim.V2NIMSignallingService.callSetup(params.params)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async createRoom(params:{channelType: V2NIMSignallingChannelType, channelName?: string, channelExtension?: string}): Promise<NIMResult<V2NIMSignallingChannelInfo>> {
    try {
      return successRes(
        await this.nim.V2NIMSignallingService.createRoom(params.channelType,params.channelName,params.channelExtension)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async closeRoom(params:{channelId: string, offlineEnabled?: boolean, serverExtension?: string}): Promise<NIMResult<void>> {
    try {
      return successRes(
            await this.nim.V2NIMSignallingService.closeRoom(params.channelId,params.offlineEnabled,params.serverExtension)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async joinRoom(params:{params:V2NIMSignallingJoinParams}): Promise<NIMResult<V2NIMSignallingRoomInfo>> {
    try {
      return successRes(await this.nim.V2NIMSignallingService.joinRoom(params.params)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async leaveRoom(params:{channelId: string, offlineEnabled?: boolean, serverExtension?: string}){
    try {
      return successRes(
        await this.nim.V2NIMSignallingService.leaveRoom(params.channelId,params.offlineEnabled,params.serverExtension)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async invite(params:{params:V2NIMSignallingInviteParams}): Promise<NIMResult<void>> {
    try {
      return successRes(
        await this.nim.V2NIMSignallingService.invite(params.params)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async cancelInvite(params:{params:V2NIMSignallingCancelInviteParams}): Promise<NIMResult<void>> {
    try {
      return successRes(await this.nim.V2NIMSignallingService.cancelInvite(params.params)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async rejectInvite(params:{params:V2NIMSignallingRejectInviteParams}): Promise<NIMResult<void>> {
    try {
      return successRes(await this.nim.V2NIMSignallingService.rejectInvite(params.params)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async acceptInvite(params:{params:V2NIMSignallingAcceptInviteParams}): Promise<NIMResult<void>> {
    try {
      return successRes(await this.nim.V2NIMSignallingService.acceptInvite(params.params)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async sendControl(params:{channelId: string, receiverAccountId?: string, serverExtension?: string}): Promise<NIMResult<void>> {
    try {
      return successRes(
            await this.nim.V2NIMSignallingService.sendControl(params.channelId,params.receiverAccountId,params.serverExtension)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  @loggerDec
  async getRoomInfoByChannelName(params:{channelName: string}): Promise<NIMResult<V2NIMSignallingRoomInfo>> {
    try {
      return successRes(await this.nim.V2NIMSignallingService.getRoomInfoByChannelName(params.channelName)
      )
    } catch (error) {
      throw failRes(error as V2NIMError)
    }
  }

  private _onOnlineEvent(event: V2NIMSignallingEvent): void {
    logger.log('_onOnlineEvent')
    emit('SignallingService', 'onOnlineEvent',  event)
  }

  private _onOfflineEvent(events: V2NIMSignallingEvent[]): void {
      logger.log('onOfflineEvent')
      emit('SignallingService', 'onOfflineEvent', { offlineEvents: events })
    }

  private _onMultiClientEvent(event: V2NIMSignallingEvent): void {
      logger.log('onMultiClientEvent')
      emit('SignallingService', 'onMultiClientEvent', event )
    }

  private _onSyncRoomInfoList(roomList: V2NIMSignallingRoomInfo[]): void {
      logger.log('onSyncRoomInfoList')
      emit('SignallingService', 'onSyncRoomInfoList', { syncRoomInfoList: roomList })
    }
}

export default SignallingService
