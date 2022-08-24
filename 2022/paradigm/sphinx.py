import asyncio
from starknet_py.net.gateway_client import GatewayClient
from starknet_py.net.models import StarknetChainId
from starknet_py.net import AccountClient
from starknet_py.contract import Contract
from starknet_py.cairo import felt
from starkware.python.utils import to_bytes

contract_add = "0x770361326a2dc15567474964cebb231623ef0ccc1b5db00db0e5a6828cff1"

async def main():
    await call()


async def call():
    gateway_client = GatewayClient(
        "http://3482c02a-9e36-401f-9808-82a2a6543267@35.193.19.12:5050", chain=StarknetChainId.TESTNET
    )
    print("============\n")
    acc_client = await AccountClient.create_account(private_key=0xa678f5b76078d990b222d340fe0aafb5,
        client=gateway_client, chain=StarknetChainId.TESTNET
    )
    #print(await acc_client.get_balance(0x073314940630fd6dcda0d772d4c972c4e0a9946bef9dabf4ef84eda8ef542b82))

    contract = await Contract.from_address(client=acc_client, address=contract_add)
    print("\n============\n")

    await(
        await contract.functions["solve"].invoke(
        solution='man', max_fee=int(0)
    )).wait_for_acceptance()

    print("\n============\n")

    solution = (await contract.functions["solution"].call()).solution
    print(solution)

    print( to_bytes(solution).lstrip(b"\x00") == b"man")

if __name__ == '__main__':
    asyncio.run(main())
